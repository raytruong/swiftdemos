import UIKit
import SwiftUI
import Playgrounds

class AnimatedView: UIView {
    private lazy var background: (
        view: UIView,
        leading: NSLayoutConstraint,
        trailing: NSLayoutConstraint,
        centerX: NSLayoutConstraint,
        centerY: NSLayoutConstraint,
        height: NSLayoutConstraint,
        width: NSLayoutConstraint
    ) = {
        // View
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red

        // Layer
        view.layer.opacity = 0

        // Constraints
        let leading = view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let centerX = view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerY = view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let height = view.heightAnchor.constraint(equalToConstant: 0)
        let width = view.widthAnchor.constraint(equalToConstant: 0)

        return (
            view,
            leading,
            trailing,
            centerX,
            centerY,
            height,
            width
        )
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    private func setup() {
        self.addSubview(background.view)

        NSLayoutConstraint.activate([
            background.centerX,
            background.centerY,
            background.height,
            background.width
        ])
    }

    func animate() {
        // Ensure any pending layout is applied before starting
        self.layoutIfNeeded()

        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [
                .curveEaseInOut,
                .autoreverse,
                .repeat
            ],
            animations: {
                self.background.view.layer.opacity = 1
                self.background.height.constant = 200
                self.background.width.constant = 200
                self.layoutIfNeeded() // ensures the final layout is fully computed before interpolation
            },
            completion: nil
        )
    }


    func animateComplex() {
        // Ensure any pending layout is applied before starting
        self.layoutIfNeeded()

        let timing = UISpringTimingParameters(dampingRatio: 0.6, initialVelocity: CGVector(dx: 0.8, dy: 0.8))
        let animator = UIViewPropertyAnimator(duration: 2, timingParameters: timing)

        // Primary animations: constraints + opacity
        animator.addAnimations {
            self.background.view.layer.opacity = 1
            self.background.height.constant = 200
            self.background.width.constant = 200
            self.layoutIfNeeded()
        }

        // Simultaneous animation: scale bounce
        animator.addAnimations({
            self.background.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, delayFactor: 0)

        // Autoreverse + repeat using completion to chain reversals
        animator.addCompletion { position in
            // Toggle target state for reverse
            let isExpanded = self.background.height.constant == 200
            self.background.height.constant = isExpanded ? 0 : 200
            self.background.leading.constant = isExpanded ? 0 : 100
            self.background.trailing.constant = isExpanded ? 0 : -100
            self.background.view.layer.opacity = isExpanded ? 0 : 1
            self.background.view.transform = isExpanded ? .identity : CGAffineTransform(scaleX: 1.1, y: 1.1)

            // Start the reverse with the same spring, then chain again
            let reverseAnimator = UIViewPropertyAnimator(duration: 2, timingParameters: timing)
            reverseAnimator.addAnimations {
                self.layoutIfNeeded()
            }
            reverseAnimator.addCompletion { _ in
                // Loop
                self.animate()
            }
            reverseAnimator.startAnimation()
        }

        animator.startAnimation()
    }
}

struct AnimatedViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> AnimatedView {
        let view = AnimatedView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            view.animate()
        }
        return view
    }

    func updateUIView(_ uiView: AnimatedView, context: Context) {}
}

struct AnimatedHostView: View {
    var body: some View {
        AnimatedViewRepresentable()
            .border(.green)
    }
}

#Preview {
    AnimatedHostView()
}
