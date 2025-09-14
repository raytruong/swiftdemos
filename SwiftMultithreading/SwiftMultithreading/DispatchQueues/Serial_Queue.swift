import Foundation
import Playgrounds

#Playground {
    // Demo: Serial queue executes tasks in strict order
    let serialQueue = DispatchQueue(label: "com.example.serialQueue")

    logCtx("starting serial queue")

    for i in 1...4 {
        serialQueue.async {
            logCtx("Task \(i) started")
            Thread.sleep(forTimeInterval: 0.1) // Simulate some work
            logCtx("Task \(i) finished")
        }
    }

    serialQueue.async {
        logCtx("All tasks submitted to serial queue have finished in order.")
    }
}
