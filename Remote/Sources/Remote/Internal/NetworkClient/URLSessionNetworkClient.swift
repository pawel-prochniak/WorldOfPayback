import Foundation
import Combine

public final class URLSessionNetworkClient {
    private let urlSession: URLSession
    private let baseUrl: String
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    
    public init(
        urlSession: URLSession,
        jsonDecoder: JSONDecoder,
        jsonEncoder: JSONEncoder,
        baseUrl: String
    ) {
        self.urlSession = urlSession
        self.baseUrl = baseUrl
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }
}
