import Foundation
import Observation

@Observable
final class HomeViewModel {

    var isWeeklyFilter     = true
    var showAddTransaction = false

    private unowned let repository: LocalRepository

    init(repository: LocalRepository) {
        self.repository = repository
    }

    struct TransactionGroup: Identifiable {
        let id: String
        let sortKey: Date
        let title: String
        let transactions: [Transaction]

        var totalIncome: Double  { transactions.filter { $0.type == .income  }.reduce(0) { $0 + $1.amount } }
        var totalExpense: Double { transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount } }
    }

    var currentUser: User? { repository.currentUser }

    var firstName: String {
        repository.currentUser?.fullName.components(separatedBy: " ").first ?? "there"
    }

    var greeting: String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 5..<12:  return "Good morning"
        case 12..<17: return "Good afternoon"
        default:      return "Good evening"
        }
    }

    var groupedTransactions: [TransactionGroup] {
        isWeeklyFilter ? weeklyGroups : monthlyGroups
    }

    var monthlyIncome: Double {
        currentMonthTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    var monthlyExpenses: Double {
        currentMonthTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }

    func currencySymbol(for currencyId: String) -> String {
        repository.currencies.first(where: { $0.id == currencyId })?.symbol ?? "$"
    }

    func toggleFavorite(id: UUID) { repository.toggleFavorite(id: id) }
    func deleteTransaction(id: UUID) { repository.deleteTransaction(id: id) }

    private var monthlyGroups: [TransactionGroup] {
        guard !repository.transactions.isEmpty else { return [] }
        let cal = Calendar.current
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"

        var dict: [Date: [Transaction]] = [:]
        for tx in repository.transactions {
            let comps  = cal.dateComponents([.year, .month], from: tx.date)
            let anchor = cal.date(from: comps) ?? tx.date
            dict[anchor, default: []].append(tx)
        }
        return dict.map { anchor, txs in
            TransactionGroup(id: fmt.string(from: anchor), sortKey: anchor,
                             title: fmt.string(from: anchor),
                             transactions: txs.sorted { $0.date > $1.date })
        }.sorted { $0.sortKey > $1.sortKey }
    }

    private var weeklyGroups: [TransactionGroup] {
        guard !repository.transactions.isEmpty else { return [] }
        let cal = Calendar.current
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM d"

        var dict: [Date: [Transaction]] = [:]
        for tx in repository.transactions {
            let start = cal.dateInterval(of: .weekOfYear, for: tx.date)?.start ?? tx.date
            dict[start, default: []].append(tx)
        }
        return dict.map { start, txs in
            let end = cal.date(byAdding: .day, value: 6, to: start) ?? start
            return TransactionGroup(
                id: start.ISO8601Format(), sortKey: start,
                title: "\(fmt.string(from: start)) – \(fmt.string(from: end))",
                transactions: txs.sorted { $0.date > $1.date }
            )
        }.sorted { $0.sortKey > $1.sortKey }
    }

    private var currentMonthTransactions: [Transaction] {
        repository.transactions.filter {
            Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }
    }
}
