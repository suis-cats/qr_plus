import SwiftUI

struct HistoryView: View {
    @ObservedObject var historyStore: HistoryStore

    var body: some View {
        List(historyStore.items) { item in
            VStack(alignment: .leading) {
                Text(item.content)
                    .font(.body)
                Text(item.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("History")
    }
}
