import Combine

protocol TransactionListProvider {
    func getTransactions() -> AnyPublisher<[RemoteTransaction], Error>
}
