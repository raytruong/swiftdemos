import SwiftUI

struct SwiftUITextLayoutLabView: View {
    @State private var containerWidth: CGFloat = 750

    private let veryLong = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. \
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
    """

    private let short = "Hello"

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Interactive Control
                VStack(alignment: .leading, spacing: 8) {
                    Slider(value: $containerWidth, in: 50...1000)
                    Text("Container Width: \(Int(containerWidth)) pt")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // MARK: - fixedSize Basics & Permutations
                        Text("fixedSize: Basics & Permutations")
                            .font(.headline)

                        // Figure 1: fixedSize basics
                        Figure(
                            number: 1,
                            title: "fixedSize basics (vertical growth)",
                            explanation: "fixedSize(horizontal: false, vertical: true) lets Text wrap naturally and grow in height to avoid truncation, without forcing extra horizontal expansion."
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                CodeBlock(code: """
                                Text(veryLong)
                                    .fixedSize(horizontal: false, vertical: true)
                                """)
                                Text(veryLong)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .background(Color.blue.opacity(0.1))
                            }
                        }

                        // Figure 2: fixedSize permutations
                        Figure(
                            number: 2,
                            title: "fixedSize permutations by axis",
                            explanation: "Compare axis settings and their effects on wrapping, overflow, and height. Baseline shows default wrapping; other rows demonstrate how fixedSize changes layout."
                        ) {
                            VStack(alignment: .leading, spacing: 10) {
                                VStack(alignment: .leading, spacing: 6) {
                                    CodeBlock(code: """
                                    Text(veryLong)
                                    """)
                                    Text(veryLong)
                                        .background(Color.blue.opacity(0.1))
                                }
                                VStack(alignment: .leading, spacing: 6) {

                                    CodeBlock(code: """
                                    Text(veryLong)
                                        .fixedSize(horizontal: false, vertical: true)
                                    """)
                                    Text(veryLong)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .background(Color.blue.opacity(0.1))
                                }
                                VStack(alignment: .leading, spacing: 6) {

                                    CodeBlock(code: """
                                    Text(veryLong)
                                        .fixedSize(horizontal: true, vertical: false)
                                    """)
                                    ScrollView(.horizontal) {
                                        Text(veryLong)
                                            .fixedSize(horizontal: true, vertical: false)
                                            .background(Color.blue.opacity(0.1))
                                    }
                                }
                                VStack(alignment: .leading, spacing: 6) {

                                    CodeBlock(code: """
                                    Text(veryLong)
                                        .fixedSize(horizontal: true, vertical: true)
                                    """)
                                    ScrollView(.horizontal) {
                                        Text(veryLong)
                                            .fixedSize(horizontal: true, vertical: true)
                                            .background(Color.blue.opacity(0.1))
                                    }
                                }
                            }
                        }

                        // MARK: - Greedy Comparison
                        Text("Greedy Comparison")
                            .font(.headline)

                        Figure(
                            number: 3,
                            title: "Non-greedy VStack: Text alone",
                            explanation: "Without a greedy sibling, the VStack sizes closely to the Text’s intrinsic size within the container width."
                        ) {
                            VStack {
                                Text(short)
                                    .background(Color.blue.opacity(0.1))
                            }
                            .border(.green)
                        }

                        Figure(
                            number: 4,
                            title: "Greedy sibling forces expansion",
                            explanation: "A Color.red with a fixed height is horizontally greedy by default, causing the VStack to expand to the container’s width."
                        ) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(short)
                                    .background(Color.blue.opacity(0.1))
                                Color.red
                                    .frame(height: 5)
                            }
                            .border(.green)
                        }

                        // MARK: - Additional Permutations
                        Text("Additional Permutations")
                            .font(.headline)

                        Figure(
                            number: 5,
                            title: "Standard Text (no modifiers)",
                            explanation: "Text wraps based on the container width, taking as many lines as needed."
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                CodeBlock(code: """
                                Text(veryLong)
                                """)
                                Text(veryLong)
                                    .background(Color.blue.opacity(0.1))
                            }
                        }

                        Figure(
                            number: 6,
                            title: "Single-line shrink-to-fit",
                            explanation: "lineLimit(1) forces a single line; minimumScaleFactor(0.5) allows scaling down to half size to avoid truncation when possible. This only works when we enforce a line limit, as the scale factor only applies as last resort."
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                CodeBlock(code: """
                                Text(veryLong)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                """)
                                Text(veryLong)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .background(Color.blue.opacity(0.1))
                            }
                        }

                        Figure(
                            number: 7,
                            title: "Horizontal overflow with fixedSize(horizontal: true)",
                            explanation: "Disables wrapping so long text extends beyond the container. Use horizontal scrolling to reveal clipped content."
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                CodeBlock(code: """
                                Text(veryLong)
                                    .fixedSize(horizontal: true, vertical: false)
                                """)
                                ScrollView(.horizontal) {
                                    Text(veryLong)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .background(Color.blue.opacity(0.1))
                                }
                            }
                        }
                    }
                    .frame(width: containerWidth, alignment: .leading)
                    .padding()
                }
            }
            .navigationTitle("Text Layout Lab")
        }
    }
}

#Preview {
    SwiftUITextLayoutLabView()
}
