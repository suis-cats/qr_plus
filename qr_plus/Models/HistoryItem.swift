import Foundation


enum QRContentType: String, Codable {
    case url = "URL"
    case phone = "Phone"
    case email = "Email"
    case wifi = "WiFi"
    case text = "Text"
}


struct HistoryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String
    let date: Date

    let type: QRContentType

    init(id: UUID = UUID(), content: String, date: Date = Date(), type: QRContentType) {

        self.id = id
        self.content = content
        self.date = date
        self.type = type
    }
}
