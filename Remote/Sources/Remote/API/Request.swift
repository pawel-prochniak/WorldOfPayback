public struct Request {
    public let path: String
    public let method: Method
    public let body: Encodable?
    public let queryItems: [String: String?]
    public let headers: [String: String]
    
    public init(
        endpoint: String,
        method: Method,
        body: Encodable? = nil,
        queryItems: [String: String?] = [:],
        headers: [String: String] = [:]
    ) {
        self.path = endpoint
        self.method = method
        self.body = body
        self.queryItems = queryItems
        self.headers = headers
    }
    
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}
