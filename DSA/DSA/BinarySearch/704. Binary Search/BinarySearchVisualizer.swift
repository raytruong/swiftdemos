import SwiftUI

// A simple model to represent an item in our array.
struct ArrayItem: Identifiable {
    let id = UUID()
    let value: Int
    var state: ItemState = .initial
}

enum ItemState {
    case initial // Default state
    case inRange // Part of the current search range
    case midCheck // The element currently being checked
    case found // The element that was found
    case outsideRange // Elements outside the current search range
}

// A simple model for the state of the visualizer.
enum VisualizerState {
    case idle
    case searching
    case found
    case notFound
}

struct BinarySearchVisualizer: View {
    @State private var items: [ArrayItem] = []
    @State private var leftIndex: Int? = nil
    @State private var rightIndex: Int? = nil
    @State private var midIndex: Int? = nil
    @State private var statusMessage: String = "Enter a target and tap 'Start'."
    @State private var visualizerState: VisualizerState = .idle

    let initialArray: [Int]
    private let animationDuration: Double = 0.5
    private let pauseDuration: Double = 3
    private var isSearching: Bool { visualizerState == .searching }

    // Custom color mapping for the item states
    private func color(for state: ItemState) -> Color {
        switch state {
        case .initial: return .gray.opacity(0.3)
        case .inRange: return .blue.opacity(0.5)
        case .midCheck: return .orange
        case .found: return .green
        case .outsideRange: return .gray.opacity(0.1)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Binary Search Visualizer")
                .font(.largeTitle)
                .fontWeight(.bold)

            // The main array visualization
            ScrollView(.horizontal) {
                HStack(alignment: .bottom, spacing: 5) {
                    ForEach(items.indices, id: \.self) { index in
                        VStack {
                            Text(isPointer(index: index) ? pointerText(index: index) : "")
                                .font(.footnote)
                                .offset(y: -15)

                            RoundedRectangle(cornerRadius: 8)
                                .fill(color(for: items[index].state))
                                .frame(width: 40, height: CGFloat(items[index].value) * 1.5)

                            Text("\(items[index].value)")
                                .font(.headline)

                            Text("\(index)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 2)
                        .animation(.easeInOut(duration: animationDuration), value: items[index].state)
                        .onTapGesture {
                            startSearch(target: items[index].value)
                        }
                    }
                }
                .padding()
            }

            // Status message
            Text(statusMessage)
                .font(.body)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)

            Spacer()
        }
        .padding()
        .onAppear {
            reset()
        }
    }

    // Helper to determine what pointer text to show
    private func pointerText(index: Int) -> String {
        var text = ""
        if leftIndex == index { text += "L" }
        if midIndex == index { text += text.isEmpty ? "M" : ", M" }
        if rightIndex == index { text += text.isEmpty ? "R" : ", R" }
        return text
    }

    private func isPointer(index: Int) -> Bool {
        leftIndex == index || rightIndex == index || midIndex == index
    }

    // Resets the visualization to its initial state
    private func reset() {
        items = initialArray.map { ArrayItem(value: $0) }
        withAnimation {
            leftIndex = nil
            rightIndex = nil
            midIndex = nil
            visualizerState = .idle
            statusMessage = "Enter a target and tap 'Start'."
        }
    }

    // The main function to start the binary search process
    private func startSearch(target: Int) {
        // Reset and set the initial state
        reset()
        visualizerState = .searching

        Task {
            var left = 0
            var right = items.count - 1

            withAnimation {
                leftIndex = left
                rightIndex = right
                statusMessage = "Initial range: indices \(left) to \(right)."
                for i in items.indices {
                    items[i].state = .inRange
                }
            }

            try await Task.sleep(nanoseconds: UInt64(pauseDuration * 1_000_000_000))

            while left <= right {
                let mid = left + (right - left) / 2

                withAnimation {
                    midIndex = mid
                    items[mid].state = .midCheck
                    statusMessage = "Checking middle element at index \(mid), value is \(items[mid].value)."
                }

                try await Task.sleep(nanoseconds: UInt64(pauseDuration * 1_000_000_000))

                if items[mid].value == target {
                    withAnimation {
                        items[mid].state = .found
                        leftIndex = nil
                        rightIndex = nil
                        midIndex = nil
                        statusMessage = "Found target \(target)! It's at index \(mid)."
                        visualizerState = .found
                    }
                    return
                } else if items[mid].value < target {
                    left = mid + 1
                    withAnimation {
                        statusMessage = "Target > \(items[mid].value). Discarding left half."
                        for i in items.indices where i <= mid {
                            items[i].state = .outsideRange
                        }
                        leftIndex = left
                        midIndex = nil
                    }
                } else {
                    right = mid - 1
                    withAnimation {
                        statusMessage = "Target < \(items[mid].value). Discarding right half."
                        for i in items.indices where i >= mid {
                            items[i].state = .outsideRange
                        }
                        rightIndex = right
                        midIndex = nil
                    }
                }

                try await Task.sleep(nanoseconds: UInt64(pauseDuration * 1_000_000_000))
            }

            // Target not found
            withAnimation {
                leftIndex = nil
                rightIndex = nil
                midIndex = nil
                for i in items.indices {
                    items[i].state = .outsideRange
                }
                statusMessage = "Target \(target) not found in the array."
                visualizerState = .notFound
            }
        }
    }
}

#Preview {
//    BinarySearchVisualizer(initialArray: [-1, 0, 3, 5, 9, 12, 24, 50, 100])
    BinarySearchVisualizer(initialArray: [5])
}
