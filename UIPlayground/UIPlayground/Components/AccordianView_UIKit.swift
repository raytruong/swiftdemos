import Foundation
import SwiftUI
import UIKit

struct ViewHoster: UIViewRepresentable {
    typealias UIViewType = AccordianViewUIKit

    let hostedView: UIViewType

    func makeUIView(context: Context) -> UIViewType {
        return hostedView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

class AccordianViewUIKit: UIView {
    let title: String
    let subtitle: String
    private var isExpanded: Bool = false
    private var bottomToTitleConstraint: NSLayoutConstraint?
    private var bottomToSubtitleConstraint: NSLayoutConstraint?

    private lazy var tappableArea: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear

        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(onCardTap), for: .touchUpInside)

        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemGreen.cgColor

        return button
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = self.title
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = self.subtitle
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    }()

    private lazy var chevronRight: UIImageView = {
        let chevronImage = UIImage(systemName: "chevron.right")!
        let imageView = UIImageView(image: chevronImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        super.init(frame: .zero) // set up with initial frame of zero, but will resize later
        setupViews()
    }

    required init?(coder: NSCoder) { // storyboard initialization
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(chevronRight)
        addSubview(tappableArea)

        setContentHuggingPriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronRight.leadingAnchor, constant: -8),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            chevronRight.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            chevronRight.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            chevronRight.widthAnchor.constraint(equalToConstant: 12),
            chevronRight.heightAnchor.constraint(equalToConstant: 18),

            tappableArea.topAnchor.constraint(equalTo: topAnchor),
            tappableArea.leadingAnchor.constraint(equalTo: leadingAnchor),
            tappableArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            tappableArea.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        // Bottom anchors to make the view hug its content
        bottomToTitleConstraint = bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        bottomToSubtitleConstraint = bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10)

        bottomToTitleConstraint?.isActive = true
        bottomToSubtitleConstraint?.isActive = false

        chevronRight.alpha = 1.0
        chevronRight.transform = .identity

        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemRed.cgColor

        subtitleLabel.isHidden = true
        subtitleLabel.alpha = 0.0
    }

    @objc func onCardTap() {
        isExpanded.toggle()
        let angle: CGFloat = isExpanded ? (.pi / 2) : 0 // 90 degrees

        // Prepare visibility before layout animation
        if isExpanded {
            subtitleLabel.isHidden = false
        }

        // Toggle which bottom constraint is active
        bottomToTitleConstraint?.isActive = !isExpanded
        bottomToSubtitleConstraint?.isActive = isExpanded

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self else { return }
            self.chevronRight.transform = CGAffineTransform(rotationAngle: angle)
            self.subtitleLabel.alpha = self.isExpanded ? 1.0 : 0.0
            self.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let self else { return }
            // After collapsing, hide to remove from accessibility and hit-testing while keeping layout correct
            if !self.isExpanded {
                self.subtitleLabel.isHidden = true
            }
            // Notify layout system that our natural size changed
            self.invalidateIntrinsicContentSize()
            self.setNeedsLayout()
            self.superview?.setNeedsLayout()
            self.superview?.layoutIfNeeded()
        })
    }
}

#Preview {
    let hostedView = AccordianViewUIKit(
        title: "Hello title",
        subtitle: "hello subtitle"
    )
    return ViewHoster(hostedView: hostedView)
        .frame(maxHeight: 200)
}
