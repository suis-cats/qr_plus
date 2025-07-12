import SwiftUI
import AVFoundation

struct ScannerView: UIViewRepresentable {
    @ObservedObject var viewModel: ScannerViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        if let layer = viewModel.getPreviewLayer() {
            layer.frame = view.bounds
            layer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(layer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = viewModel.getPreviewLayer() {
            layer.frame = uiView.bounds
        }
    }
}
