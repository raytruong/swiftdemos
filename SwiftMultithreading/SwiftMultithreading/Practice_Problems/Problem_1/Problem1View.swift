import SwiftUI

/******************************************************************************
* Problem 1 demonstrates UI blocking and poor thread management:
* • Main thread blocking: Heavy computation freezes the entire interface
* • Unresponsive UI: Counter button becomes completely unresponsive
* • Synchronous execution: All operations run sequentially on main thread
* • Poor user experience: App appears frozen until computation completes
* This serves as a "before" example contrasting with Problem 2's approach
******************************************************************************/

struct Problem1View: View {
    @State private var statusMessage = "Ready to start"
    @State private var counter = 0

    private func heavyComputation() {
        self.statusMessage = "Starting heavy computation..."

        let start = Date.now
        for i in 0..<50_000_000 {
            let _ = i * i
        }
        let end = Date.now

        let duration = (end.timeIntervalSince(start))
        self.statusMessage = "Completed in \(String(format: "%.2f", duration)) seconds."
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("GCD Playground")
                .font(.largeTitle)
                .padding(.bottom, 20)

            Text(statusMessage)
                .font(.headline)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)

            Button("Start Heavy Computation") {
                heavyComputation()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Increment my counter: \(counter)") {
                self.counter += 1
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    Problem1View()
}
