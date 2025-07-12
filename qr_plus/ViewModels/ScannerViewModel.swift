import Foundation
import AVFoundation
import SwiftUI

class ScannerViewModel: NSObject, ObservableObject {
    @Published var lastScanned: HistoryItem?
    @Published var isScanning = true

    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var historyStore: HistoryStore

    init(historyStore: HistoryStore) {
        self.historyStore = historyStore
        super.init()
        configureSession()
    }

    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
        }
        return previewLayer
    }

    func startRunning() {
        guard !session.isRunning else { return }

        DispatchQueue.global(qos: .userInitiated).async { [session] in
            session.startRunning()
        }

    }

    func stopRunning() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [session] in
            session.stopRunning()
        }

    }

    private func configureSession() {
        session.beginConfiguration()

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let output = AVCaptureMetadataOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.qr]
        }

        session.commitConfiguration()
    }
}

extension ScannerViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard isScanning,
              let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = object.stringValue else { return }

        isScanning = false

        let type = classify(value)
        let item = HistoryItem(content: value, type: type)
        lastScanned = item
        historyStore.add(item)
    }
}

extension ScannerViewModel {
    func classify(_ value: String) -> QRContentType {
        let lower = value.lowercased()
        if lower.hasPrefix("http://") || lower.hasPrefix("https://") {
            return .url
        }
        if lower.hasPrefix("tel:") {
            return .phone
        }
        if lower.hasPrefix("mailto:") || (value.contains("@") && value.contains(".")) {
            return .email
        }
        if lower.hasPrefix("wifi:") {
            return .wifi
        }
        return .text
    }
}

