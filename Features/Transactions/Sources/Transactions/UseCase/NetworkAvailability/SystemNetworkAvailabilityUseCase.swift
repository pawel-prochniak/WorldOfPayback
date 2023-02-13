import Combine
import Foundation
import Network

final class SystemNetworkAvailabilityUseCase {
    private let networkMonitor: NWPathMonitor
    
    init() {
        self.networkMonitor = NWPathMonitor()
    }
}

extension SystemNetworkAvailabilityUseCase: GetNetworkAvailabilityChangesUseCase {
    func callAsFunction() -> AnyPublisher<NetworkAvailability, Never> {
        networkMonitor.publisher()
            .map(\.asNetworkAvailability)
            .eraseToAnyPublisher()
    }
}

private extension NWPath {
    var asNetworkAvailability: NetworkAvailability {
        switch status {
        case .satisfied: return .connected
        default: return .disconnected
        }
    }
}
