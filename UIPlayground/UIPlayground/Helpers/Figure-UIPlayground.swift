import SwiftUI

// A reusable wrapper that gives each example a textbook-style figure label,
// concise explanation, and a visible container border.
struct Figure<Content: View>: View {
    let number: Int
    let title: String
    let explanation: String
    @ViewBuilder let content: Content

    init(number: Int, title: String, explanation: String, @ViewBuilder content: () -> Content) {
        self.number = number
        self.title = title
        self.explanation = explanation
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Figure \(number). \(title)")
                .font(.subheadline).bold()
            Text(explanation)
                .font(.footnote)
                .foregroundStyle(.secondary)
            content
        }
        .padding(8)
        .border(Color.gray, width: 1)
    }
}
