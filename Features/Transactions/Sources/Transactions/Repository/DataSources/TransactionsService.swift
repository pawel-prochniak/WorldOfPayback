import Combine
import Remote

final class TransactionsService {
    private var networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

extension TransactionsService: TransactionListProvider {
    func getTransactions() -> AnyPublisher<[RemoteTransaction], Error> {
        requestTransactions()
            .map(\.items)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    private func requestTransactions() -> AnyPublisher<TransactionsResponse, NetworkClientError> {
        networkClient.request(.transactions)
            .eraseToAnyPublisher()
    }
}
    
private extension Request {
    static let transactions = Request(
        endpoint: "/transactions",
        method: .get
    )
}
