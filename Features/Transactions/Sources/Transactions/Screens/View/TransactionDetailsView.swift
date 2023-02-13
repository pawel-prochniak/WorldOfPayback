import SwiftUI

struct TransactionDetailsView: View {
    private let transaction: Transaction
    
    init(_ transaction: Transaction) {
        self.transaction = transaction
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            Text(transaction.partnerDisplayName)
                .font(.title)
            transaction.transactionDescription.map { Text($0) }
            Spacer()
        }
    }
}
