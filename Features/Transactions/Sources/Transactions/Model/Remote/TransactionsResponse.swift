import Foundation

struct TransactionsResponse: Decodable {
    let items: [RemoteTransaction]
}

struct RemoteTransaction: Decodable {
    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail
}

extension RemoteTransaction {
    struct Alias: Decodable {
        let reference: String
    }

    struct TransactionDetail: Decodable {
        let description: String?
        let bookingDate: String
        let value: Value
    }

    struct Value: Decodable {
        let amount: Int
        let currency: String
    }
}
