import Testing
@testable import qr_plus

struct qr_plusTests {
    @Test
    func testHistoryStoreLimit() async throws {
        let store = HistoryStore(limit: 3)
        store.add(HistoryItem(content: "A", type: .text))
        store.add(HistoryItem(content: "B", type: .text))
        store.add(HistoryItem(content: "C", type: .text))
        store.add(HistoryItem(content: "D", type: .text))

        #expect(store.items.count == 3)
        #expect(store.items.first?.content == "D")
        #expect(store.items.last?.content == "B")
    }

    @Test
    func testClassification() async throws {
        let store = HistoryStore()
        let viewModel = ScannerViewModel(historyStore: store)
        #expect(viewModel.classify("https://example.com") == .url)
        #expect(viewModel.classify("tel:12345") == .phone)
        #expect(viewModel.classify("mailto:test@example.com") == .email)
        #expect(viewModel.classify("WIFI:S:MyWiFi;P:123456;;") == .wifi)
        #expect(viewModel.classify("Hello") == .text)
    }

}
