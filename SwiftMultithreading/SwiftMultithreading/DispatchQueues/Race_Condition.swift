import Foundation
import Playgrounds

final class UnsafeCounter {
    private var value: Int = 0

    func increment() {
        self.value += 1
    }

    var currentValue: Int {
        self.value
    }
}

/// A thread-safe counter using a serial DispatchQueue to prevent data corruption.
final class SafeCounter {
    private var value: Int = 0
    private let queue = DispatchQueue(label: "com.example.SafeCounterQueue")

    /// Increment the counter safely.
    func increment() {
        queue.async {
            self.value += 1
        }
    }

    /// Read the counter's value safely.
    var currentValue: Int {
        queue.sync {
            value
        }
    }
}

#Playground {
    let unsafeCounter = UnsafeCounter()
    let safeCounter = SafeCounter()

    let group = DispatchGroup()

    // Simulate concurrent increments
    for _ in 0..<10000 {
        group.enter()
        DispatchQueue.global().async {
            unsafeCounter.increment()
            safeCounter.increment()
            group.leave()
        }
    }

    group.notify(queue: .main) {
        print("Unsafe value: \(unsafeCounter.currentValue)")
        print("Safe value: \(safeCounter.currentValue)")
    }
}
