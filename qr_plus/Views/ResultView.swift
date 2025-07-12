import SwiftUI

struct ResultView: View {
    let item: HistoryItem

    var body: some View {
        VStack(spacing: 20) {
            Text(item.content)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(item.type.rawValue)
                .font(.subheadline)
                .foregroundColor(.secondary)
            ShareLink(item: item.content) {

                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
        .padding()
        .navigationTitle("Result")
    }
}
