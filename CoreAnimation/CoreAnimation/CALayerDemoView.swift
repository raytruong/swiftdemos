import UIKit

class CALayerDemoView: UIView {
    var layerBackgroundColor: UIColor? {
        didSet {
            self.layer.backgroundColor = layerBackgroundColor?.cgColor
        }
    }
    var layerBorderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = layerBorderWidth
        }
    }
    var layerBorderColor: UIColor? {
        didSet {
            self.layer.borderColor = layerBorderColor?.cgColor
        }
    }
    var layerCornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = layerCornerRadius
            self.layer.masksToBounds = layerCornerRadius > 0
        }
    }
    var layerShadowColor: UIColor? {
        didSet {
            self.layer.shadowColor = layerShadowColor?.cgColor
        }
    }
    var layerShadowOpacity: Float = 0 {
        didSet {
            self.layer.shadowOpacity = layerShadowOpacity
        }
    }
    var layerShadowOffset: CGSize = .zero {
        didSet {
            self.layer.shadowOffset = layerShadowOffset
        }
    }
    var layerShadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = layerShadowRadius
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaults()
    }

    private func setupDefaults() {
        self.layer.backgroundColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
        self.layer.cornerRadius = 0
        self.layer.shadowColor = nil
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 0
    }
}
