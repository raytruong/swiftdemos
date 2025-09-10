import SwiftUI

/******************************************************************************
* Problem 2 demonstrates:
* • Quality of Service (QOS) priority levels for background tasks
* • Concurrent programming with DispatchQueue to keep UI responsive
* • Real-time tracking of computation history with completion status
* • How different QOS classes affect task scheduling and performance
******************************************************************************/

struct Problem2View: View {
    @State private var counter = 0

    @State private var selectedQOS: ComputationQOS = .utility
    @State private var history: [ComputationHistoryEntry] = []

    private func heavyComputation() {
        let qosClass = selectedQOS.qosClass
        let newEntry = ComputationHistoryEntry(qos: selectedQOS, isCompleted: false, duration: nil, enqueueTimestamp: Date())
        DispatchQueue.main.async {
            history.insert(newEntry, at: 0)
        }
        let entryID = newEntry.id

        DispatchQueue.global(qos: qosClass).async {
            let start = Date.now
            for i in 0..<50_000_000 {
                let _ = i * i
            }
            let end = Date.now
            let duration = (end.timeIntervalSince(start))

            DispatchQueue.main.async {
                if let index = history.firstIndex(where: { $0.id == entryID }) {
                    history[index].isCompleted = true
                    history[index].duration = duration
                }
            }
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Picker("Select QOS", selection: $selectedQOS) {
                ForEach(ComputationQOS.allCases) { qos in
                    Text(qos.description).tag(qos)
                }
            }
            .pickerStyle(.menu)
            .padding(.horizontal)
            .padding(.vertical, 8)
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

            historyList()
        }
        .padding()
    }
}

private extension Problem2View {
    @ViewBuilder
    func historyList() -> some View {
        List(history) { entry in
            historyEntryView(for: entry)
                .padding(.vertical, 4)
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    func historyEntryView(for entry: ComputationHistoryEntry) -> some View {
        HStack(alignment: .top, spacing: 12) {
            if entry.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.2)
                    .frame(width: 24, height: 24)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("QOS: \(entry.qos.description)")
                    .font(.headline)
                Text("Enqueued: \(entry.enqueueTimestamp.formatted(date: .numeric, time: .standard))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                if entry.isCompleted, let duration = entry.duration {
                    Text("Duration: \(String(format: "%.2f", duration)) seconds")
                        .font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    Problem2View()
}
