import Combine
import Foundation

protocol TransactionRepository {
    func getTransactions() -> AnyPublisher<[RemoteTransaction], TransactionRepositoryError>
}

enum TransactionRepositoryError: LocalizedError {
    case dataFetchingFailed(error: Error?)
}
