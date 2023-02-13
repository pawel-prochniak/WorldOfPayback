import Combine
import Foundation

final class LocalTransactionsRepository {
    private let localTransactionsProvider: LocalTransactionsListProvider
    
    init(localTransactionsProvider: LocalTransactionsListProvider = LocalTransactionsListProvider()) {
        self.localTransactionsProvider = localTransactionsProvider
    }
}

extension LocalTransactionsRepository: TransactionRepository {
    func getTransactions() -> AnyPublisher<[RemoteTransaction], TransactionRepositoryError> {
        localTransactionsProvider.getTransactions()
            .mapError(TransactionRepositoryError.dataFetchingFailed)
            .eraseToAnyPublisher()
    }
}
