import SwiftUI

struct HistoryView: View {
    @ObservedObject var historyStore: HistoryStore

    var body: some View {
        List(historyStore.items) { item in
            VStack(alignment: .leading, spacing: 4) {
                Text(item.content)
                    .font(.body)
                Text(item.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(item.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("History")
    }
}
