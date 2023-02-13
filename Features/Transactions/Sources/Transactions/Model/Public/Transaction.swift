import Foundation

public struct Transaction: Identifiable {
    public var id: String { transactionReference }
    public let transactionReference: String
    public let transactionDescription: String?
    public let partnerDisplayName: String
    public let category: Int
    public let bookingDate: Date
    public let transactionGross: Int
    public let transactionCurrency: String
}

extension Transaction {
    static func from(_ remote: RemoteTransaction, dateFormatter: DateFormatter) -> Transaction? {
        guard let bookingDate = dateFormatter.date(from: remote.transactionDetail.bookingDate) else {
            return nil
        }
        return Transaction(
            transactionReference: remote.alias.reference,
            transactionDescription: remote.transactionDetail.description,
            partnerDisplayName: remote.partnerDisplayName,
            category: remote.category,
            bookingDate: bookingDate,
            transactionGross: remote.transactionDetail.value.amount,
            transactionCurrency: remote.transactionDetail.value.currency
        )
    }
}
