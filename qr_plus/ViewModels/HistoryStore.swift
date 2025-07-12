import Foundation
import SwiftUI

class HistoryStore: ObservableObject {
    @Published private(set) var items: [HistoryItem] = []
    private let limit: Int
    private let defaultsKey = "HistoryItems"

    init(limit: Int = 10) {
        self.limit = limit
        load()
    }

    func add(_ item: HistoryItem) {
        items.insert(item, at: 0)
        if items.count > limit {
            items.removeLast()
        }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let decoded = try? JSONDecoder().decode([HistoryItem].self, from: data) else {
            items = []
            return
        }
        items = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }
}
