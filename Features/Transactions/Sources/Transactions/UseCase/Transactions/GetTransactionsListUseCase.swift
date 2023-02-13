import Combine

protocol GetTransactionsUseCase {
    func callAsFunction() -> AnyPublisher<[Transaction], GetTransactionsUseCaseError>
}

enum GetTransactionsUseCaseError: Error {
    case dataFetchingFailed(error: Error)
}
