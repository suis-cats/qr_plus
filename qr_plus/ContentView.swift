import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var historyStore: HistoryStore
    @StateObject private var scannerViewModel: ScannerViewModel

    init() {
        let store = HistoryStore()
        _historyStore = StateObject(wrappedValue: store)
        _scannerViewModel = StateObject(wrappedValue: ScannerViewModel(historyStore: store))
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScannerView(viewModel: scannerViewModel)
                    .onAppear { scannerViewModel.startRunning() }
                    .onDisappear { scannerViewModel.stopRunning() }
                    .overlay(alignment: .bottom) {
                        if let item = scannerViewModel.lastScanned {
                            NavigationLink(destination: ResultView(item: item)) {
                                Text("Show Result")
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding()
                        }
                    }
            }
            .navigationTitle("QuickQR")
            .toolbar {
                NavigationLink(destination: HistoryView(historyStore: historyStore)) {
                    Label("History", systemImage: "clock")
                }
            }
            .alert("Camera access is required to scan QR codes. Please enable it in Settings.", isPresented: $scannerViewModel.permissionDenied) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

#Preview {
    ContentView()
}
