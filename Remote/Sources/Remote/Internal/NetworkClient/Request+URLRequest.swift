
import Foundation

internal extension URLRequest {
    static func from(
        host: String,
        path: String,
        method: Request.Method,
        body: Encodable? = nil,
        additionalHeaders: [String: String],
        queryItems: [String: String?],
        encoder jsonEncoder: JSONEncoder
    ) -> Result<URLRequest, Error> {
        do {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = host
            urlComponents.path = path
            let urlQueryItems = queryItems.compactMap { key, value -> URLQueryItem? in
                guard let value else { return nil }
                return URLQueryItem(name: key, value: value)
            }
            if !urlQueryItems.isEmpty {
                urlComponents.queryItems = urlQueryItems
            }
            
            guard let url = urlComponents.url else {
                return .failure(NSError(domain: URLError.errorDomain, code: URLError.badURL.rawValue))
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            additionalHeaders.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            switch method {
            case .post, .put:
                request.httpBody = try body?.data(using: jsonEncoder)
            default: break
            }
            
            return .success(request)
        } catch {
            return .failure(error)
        }
    }
}

private extension Encodable {
    func data(using jsonEncoder: JSONEncoder) throws -> Data {
        try jsonEncoder.encode(self)
    }
}
