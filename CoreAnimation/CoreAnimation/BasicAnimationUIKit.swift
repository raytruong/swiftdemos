import UIKit
import SwiftUI
import Playgrounds

class AnimatedView: UIView {
    private lazy var background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .red
        return background
    }()
    
    private lazy var backgroundHeightConstraint: NSLayoutConstraint = {
        background.heightAnchor.constraint(equalToConstant: 150)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    private func setup() {
        self.addSubview(background)

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundHeightConstraint
//            background.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func animate() {
        UIView.animate(withDuration: 1) {
            self.background.backgroundColor = .blue
            self.backgroundHeightConstraint.constant = 250
            self.layoutIfNeeded()
        }
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
