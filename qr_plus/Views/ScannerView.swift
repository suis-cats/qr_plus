import SwiftUI
import AVFoundation

final class CameraPreview: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

struct ScannerView: UIViewRepresentable {
    @ObservedObject var viewModel: ScannerViewModel

    func makeUIView(context: Context) -> CameraPreview {
        let view = CameraPreview()
        view.previewLayer.session = viewModel.captureSession
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: CameraPreview, context: Context) {
        uiView.previewLayer.connection?.videoOrientation = .portrait
    }
}
