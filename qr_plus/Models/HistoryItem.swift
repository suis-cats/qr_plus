import Foundation

struct HistoryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String
    let date: Date
    let type: String

    init(id: UUID = UUID(), content: String, date: Date = Date(), type: String) {
        self.id = id
        self.content = content
        self.date = date
        self.type = type
    }
}
