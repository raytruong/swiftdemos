import UIKit

public enum AnimationType {
    case fadeInGrow(
        duration: Duration = .milliseconds(2000),
        delay: Duration = .milliseconds(0)
    )
}

public final class ViewAnimator {
    public func animate(
        view: UIView,
        parent: UIView,
        type: AnimationType,
        changes: @escaping () -> Void
    ) {
        switch type {
        case .fadeInGrow(let duration, let delay):
            animateFadeInGrow(
                view: view,
                in: parent,
                changes: changes,
                duration: duration,
                delay: delay
            )
        }
    }

    private func animateFadeInGrow(
        view: UIView,
        in container: UIView,
        changes: @escaping () -> Void,
        duration: Duration,
        delay: Duration
    ) {
        let duration = CGFloat(duration.components.attoseconds) / CGFloat.attosecond
        let delay = CGFloat(delay.components.attoseconds) / CGFloat.attosecond

        let durationInSeconds = TimeInterval(duration)
        let delayInSeconds = TimeInterval(delay)

        container.layoutIfNeeded()
        UIView.animate(
            withDuration: durationInSeconds,
            delay: delayInSeconds,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: {
                changes()
                container.layoutIfNeeded()
            },
            completion: nil
        )
    }
}

extension CGFloat {
    static let attosecond: CGFloat = 1_000_000_000_000_000_000
}
