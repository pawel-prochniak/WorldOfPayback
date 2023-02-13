import Combine
import SwiftUI

public struct TransactionsListView<VM: TransactionListViewModelProtocol>: View {
    @StateObject private var viewModel: VM
    
    public init(viewModel: VM = TransactionListViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationView {
            stateView
                .navigationTitle("World of PAYBACK")
                .toolbar {
                    ToolbarItem(placement: .status) {
                        if !viewModel.isNetworkAvailable {
                            Label(
                                "No internet connection",
                                systemImage: "wifi.slash"
                            )
                            .foregroundColor(.red)
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        filtersMenu
                    }
                }
        }
    }
}

private extension TransactionsListView {
    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .loading: loadingView
        case .error: errorView
        case .ready(let transactions): transactionList(of: transactions)
        }
    }
    
    var loadingView: some View {
        ProgressView()
    }
    
    var errorView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text("Something went wrong")
                .font(.title)
        }
    }
    
    func transactionList(of transactions: [Transaction]) -> some View {
        withAnimation {
            List {
                Section {
                    ForEach(transactions) { transaction in
                        NavigationLink(
                            destination: { TransactionDetailsView(transaction) }
                        ) {
                            TransactionRow(transaction)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var filtersMenu: some View {
        Menu {
            Picker(
                selection: $viewModel.activeFilter,
                content: {
                    ForEach(viewModel.availableFilters, id: \.self) {
                        Text($0.description)
                    }
                },
                label: { }
            )
        }
        label: {
            Label(
                "Filter",
                systemImage: "line.3.horizontal.decrease.circle"
            )
        }
    }
}

private extension TransactionListFilter {
    var description: String {
        switch self {
        case .all: return "All"
        case .selectedCategory(let categoryId): return "Category \(categoryId)"
        }
    }
}
