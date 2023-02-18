import Combine
import Foundation

public protocol NetworkClient {
    func request<T: Decodable>(
        _ request: Request,
        _ output: T.Type
    ) -> AnyPublisher<T, NetworkClientError>
}

public enum NetworkClientError: Error {
    case notHttpResponse
    case invalidHttpStatusCode(Int, Data?)
    case unableToConstructServerRequest(Swift.Error)
    case responseDeserializationFailure(Swift.Error)
    case internalNetworkClientFailure(URLError)
}

public extension NetworkClient {
    func request<T: Decodable>(
        _ request: Request
    ) -> AnyPublisher<T, NetworkClientError> {
        self.request(request, T.self)
    }
}
