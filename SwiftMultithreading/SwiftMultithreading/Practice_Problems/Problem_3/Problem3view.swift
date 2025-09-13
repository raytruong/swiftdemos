/******************************************************************************
 * Problem 3 demonstrates Thread Safety & Data Races:
 * • Shared mutable state accessed by multiple concurrent threads
 * • Race conditions causing data corruption and unpredictable results
 * • Solutions using serial queues and concurrent queues with barriers
 * • Comparison between unsafe and thread-safe implementations
 ******************************************************************************/

import SwiftUI

struct Problem3View: View {
    // • Shared mutable state accessed by multiple concurrent threads
    @State private var unsafeCounter = 0
    @State private var safeCounter = 0
    @State private var isRunning = false
    @State private var results: [TestResult] = []

    // • Solutions using serial queues and concurrent queues with barriers
    private let serialQueue = DispatchQueue(label: "safe-counter-queue")

    private func runUnsafeTest() {
        unsafeCounter = 0
        safeCounter = 0
        isRunning = true
        results.removeAll()

        let startTime = Date.now
        let group = DispatchGroup()

        // • Race conditions causing data corruption and unpredictable results
        // Start 10 tasks that modify the shared unsafe counter
        for _ in 0..<10 {
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                for _ in 0..<1000 {
                    // UNSAFE: Multiple threads modifying shared state without synchronization
                    self.unsafeCounter += 1

                    // • Solutions using serial queues for thread safety
                    self.serialQueue.async {
                        self.safeCounter += 1
                    }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            let duration = Date.now.timeIntervalSince(startTime)
            let expectedValue = 10 * 1000 // 10 threads × 1000 increments

            let result = TestResult(
                expectedValue: expectedValue,
                unsafeResult: self.unsafeCounter,
                safeResult: self.safeCounter,
                duration: duration,
                timestamp: Date.now
            )

            self.results.insert(result, at: 0)
            self.isRunning = false
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Thread Safety Demo")
                .font(.largeTitle)
                .padding(.bottom, 10)

            // Current counters display
            HStack(spacing: 30) {
                VStack {
                    Text("Unsafe Counter")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text("\(unsafeCounter)")
                        .font(.title)
                        .fontWeight(.bold)
                }

                VStack {
                    Text("Safe Counter")
                        .font(.headline)
                        .foregroundColor(.green)
                    Text("\(safeCounter)")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)

            // Control buttons
            HStack(spacing: 15) {
                Button("Run Race Condition Test") {
                    runUnsafeTest()
                }
                .disabled(isRunning)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

private extension Problem3View {
    @ViewBuilder
    func resultsView() -> some View {
        if !results.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Test Results")
                    .font(.headline)
            }
        }
    }
}

// • Comparison between unsafe and thread-safe implementations
struct TestResult: Identifiable {
    let id = UUID()
    let expectedValue: Int
    let unsafeResult: Int
    let safeResult: Int
    let duration: TimeInterval
    let timestamp: Date
}

#Preview {
    Problem3View()
}
