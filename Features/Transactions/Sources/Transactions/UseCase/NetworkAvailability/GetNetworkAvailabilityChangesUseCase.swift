import Combine

protocol GetNetworkAvailabilityChangesUseCase {
    func callAsFunction() -> AnyPublisher<NetworkAvailability, Never>
}

enum NetworkAvailability {
    case connected
    case disconnected
}
