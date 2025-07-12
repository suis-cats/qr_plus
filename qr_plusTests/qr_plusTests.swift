import Testing
@testable import qr_plus

struct qr_plusTests {
    @Test
    func testHistoryStoreLimit() async throws {
        let store = HistoryStore(limit: 3)
        store.add(HistoryItem(content: "A", type: "QR"))
        store.add(HistoryItem(content: "B", type: "QR"))
        store.add(HistoryItem(content: "C", type: "QR"))
        store.add(HistoryItem(content: "D", type: "QR"))
        #expect(store.items.count == 3)
        #expect(store.items.first?.content == "D")
        #expect(store.items.last?.content == "B")
    }
}
