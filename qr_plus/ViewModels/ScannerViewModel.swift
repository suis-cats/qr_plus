import Foundation
import AVFoundation
import SwiftUI

class ScannerViewModel: NSObject, ObservableObject {
    @Published var lastScanned: HistoryItem?
    @Published var isScanning = true
    @Published var permissionDenied = false

    private let session = AVCaptureSession()
    var captureSession: AVCaptureSession { session }
    private var historyStore: HistoryStore
    private var sessionConfigured = false

    init(historyStore: HistoryStore) {
        self.historyStore = historyStore
        super.init()
    }


    func startRunning() {
        checkPermissions { [weak self] granted in
            guard granted, let self else { return }
            if !self.sessionConfigured { self.configureSession() }
            guard !self.session.isRunning else { return }
            DispatchQueue.global(qos: .userInitiated).async { [session = self.session] in
                session.startRunning()
            }
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
        sessionConfigured = true
    }

    private func checkPermissions(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.permissionDenied = !granted
                    completion(granted)
                }
            }
        default:
            permissionDenied = true
            completion(false)
        }
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
