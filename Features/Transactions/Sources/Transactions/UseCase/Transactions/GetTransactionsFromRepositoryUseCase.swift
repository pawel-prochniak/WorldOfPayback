import Combine
import Foundation

final class GetTransactionsFromRepositoryUseCase {
    private let repository: TransactionRepository
    private let dateFormatter: DateFormatter
    
    init(
        repository: TransactionRepository,
        dateFormatter: DateFormatter = defaultDateFormatter
    ) {
        self.repository = repository
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.dateFormatter = dateFormatter
    }
}

extension GetTransactionsFromRepositoryUseCase: GetTransactionsUseCase {
    func callAsFunction() -> AnyPublisher<[Transaction], GetTransactionsUseCaseError> {
        repository.getTransactions()
            .mapError(GetTransactionsUseCaseError.dataFetchingFailed)
            .map { [dateFormatter] remoteTransactions in
                remoteTransactions
                    .compactMap { remote in Transaction.from(remote, dateFormatter: dateFormatter) }
                    .sorted(by: { $0.bookingDate > $1.bookingDate })
            }
            .eraseToAnyPublisher()
    }
}

private let defaultDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.locale = .current
    return formatter
}()
