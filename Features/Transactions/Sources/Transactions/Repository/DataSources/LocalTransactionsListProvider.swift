import Combine
import Foundation

final class LocalTransactionsListProvider {
    private let jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }
}

extension LocalTransactionsListProvider: TransactionListProvider {
    func getTransactions() -> AnyPublisher<[RemoteTransaction], Error> {
        let publisher: AnyPublisher<TransactionsResponse, Error>
        if Bool.random() {
            publisher = Bundle.module.url(forResource: "PBTransactions", withExtension: "json")
                .publisher
                .tryMap { try Data(contentsOf: $0) }
                .decode(type: TransactionsResponse.self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
        } else {
            publisher = Fail(error: LocalTransactionsListProviderError.loadingFailed)
                .eraseToAnyPublisher()
        }
        return publisher
            .delay(for: 2, scheduler: DispatchQueue.global())
            .map(\.items)
            .eraseToAnyPublisher()
    }
}

enum LocalTransactionsListProviderError: Error {
    case loadingFailed
}
