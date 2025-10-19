import SwiftUI
import UIKit

struct CALayerDemoRepresentable: UIViewRepresentable {
    var backgroundColor: UIColor?
    var borderWidth: CGFloat
    var borderColor: UIColor?
    var cornerRadius: CGFloat
    var shadowColor: UIColor?
    var shadowOpacity: Float
    var shadowOffset: CGSize
    var shadowRadius: CGFloat

    init(
        backgroundColor: UIColor? = nil,
        borderWidth: CGFloat = 0,
        borderColor: UIColor? = nil,
        cornerRadius: CGFloat = 0,
        shadowColor: UIColor? = nil,
        shadowOpacity: Float = 0,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = 0
    ) {
        self.backgroundColor = backgroundColor
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
    }

    func makeUIView(context: Context) -> CALayerDemoView {
        let view = CALayerDemoView()
        return view
    }

    func updateUIView(_ uiView: CALayerDemoView, context: Context) {
        uiView.layerBackgroundColor = backgroundColor
        uiView.layerBorderWidth = borderWidth
        uiView.layerBorderColor = borderColor
        uiView.layerCornerRadius = cornerRadius
        uiView.layerShadowColor = shadowColor
        uiView.layerShadowOpacity = shadowOpacity
        uiView.layerShadowOffset = shadowOffset
        uiView.layerShadowRadius = shadowRadius
    }
}
