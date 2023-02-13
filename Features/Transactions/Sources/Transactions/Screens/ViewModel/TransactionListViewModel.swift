import Combine
import Foundation

final class TransactionListViewModel: TransactionListViewModelProtocol {
    @Published var state: TransactionListState = .loading
    @Published var isNetworkAvailable = true
    @Published var activeFilter: TransactionListFilter = .all
    @Published var availableFilters: [TransactionListFilter] = []
    @Published var transactionsGross: Int?
    
    private let getTransactionsUseCase: GetTransactionsUseCase
    private let getNetworkAvailabilityChangesUseCase: GetNetworkAvailabilityChangesUseCase
    
    init(
        getTransactionsUseCase: GetTransactionsUseCase = GetTransactionsFromRepositoryUseCase(repository: LocalTransactionsRepository()),
        getNetworkAvailabilityChangesUseCase: GetNetworkAvailabilityChangesUseCase = SystemNetworkAvailabilityUseCase()
    ) {
        self.getTransactionsUseCase = getTransactionsUseCase
        self.getNetworkAvailabilityChangesUseCase = getNetworkAvailabilityChangesUseCase
        getTransactions()
        subscribeToConnectivityChanges()
    }
    
    private func getTransactions() {
        let transactionsPublisher = getTransactionsUseCase()
            .mapError(ViewModelError.fetchingDataFailed)
            .receive(on: DispatchQueue.main)
            .share()
        
        let filteredTransactionsPublisher = Publishers.CombineLatest(
            transactionsPublisher,
            $activeFilter.setFailureType(to: ViewModelError.self)
        )
            .map { (transactions, filter) -> [Transaction] in
                switch filter {
                case .all: return transactions
                case .selectedCategory(let categoryId): return transactions.filter { $0.category == categoryId }
                }
            }
            .eraseToAnyPublisher()
            .share()
        
        transactionsPublisher
            .prepend([])
            .map {
                $0.map(\.category)
                    .reduce(into: Set(), { $0.insert($1) })
                    .sorted()
                    .map { TransactionListFilter.selectedCategory($0) }
            }
            .replaceError(with: [])
            .map { fetchedCategories in
                var categories = fetchedCategories
                categories.insert(.all, at: 0)
                return categories
            }
            .assign(to: &$availableFilters)
        
        filteredTransactionsPublisher
            .map(TransactionListState.ready)
            .replaceError(with: .error)
            .assign(to: &$state)
        
        filteredTransactionsPublisher
            .map { $0.map(\.transactionGross).reduce(0, +) }
            .replaceError(with: nil)
            .assign(to: &$transactionsGross)
    }
    
    private func subscribeToConnectivityChanges() {
        getNetworkAvailabilityChangesUseCase()
            .map { availability in
                switch availability {
                case .connected: return true
                case .disconnected: return false
                }
            }
            .assign(to: &$isNetworkAvailable)
    }
}

private extension TransactionListViewModel {
    enum ViewModelError: Error {
        case fetchingDataFailed(Error)
    }
}
