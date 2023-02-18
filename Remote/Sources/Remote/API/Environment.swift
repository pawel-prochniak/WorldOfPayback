public enum Environment {
    case prod
    case test
}

public extension Environment {
    var baseUrl: String {
        switch self {
        case .prod: return "api.payback.com"
        case .test: return "api-test.payback.com"
        }
    }
}
