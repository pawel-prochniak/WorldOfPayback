import Combine

public protocol TransactionListViewModelProtocol: ObservableObject {
    var state: TransactionListState { get }
    var isNetworkAvailable: Bool { get }
    var activeFilter: TransactionListFilter { get set }
    var availableFilters: [TransactionListFilter] { get }
    var transactionsGross: Int? { get }
}

public enum TransactionListState {
    case loading
    case ready([Transaction])
    case error
}

public enum TransactionListFilter: Hashable {
    case all
    case selectedCategory(Int)
}
