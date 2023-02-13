import SwiftUI

struct TransactionRow: View {
    private let transaction: Transaction
    
    init(_ transaction: Transaction) {
        self.transaction = transaction
    }
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(transaction.partnerDisplayName)
                Spacer()
                Text(
                    transaction.transactionGross.formatted(
                        .currency(code: transaction.transactionCurrency)
                    )
                )
            }
            
            HStack {
                transaction.transactionDescription.map { Text($0) }
                Spacer()
                Text(transaction.bookingDate.formatted(date: .abbreviated, time: .shortened))
            }
            .font(.footnote)
            .opacity(0.66)
        }
        .lineLimit(1)
    }
}
