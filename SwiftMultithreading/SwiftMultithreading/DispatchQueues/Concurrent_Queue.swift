// Demo: Concurrent queues execute tasks in parallel and do NOT guarantee execution order or completion.
import Foundation
import Playgrounds

#Playground {
    let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
    let group = DispatchGroup()

    logCtx("starting work")

    for i in 1...4 {
        group.enter()
        concurrentQueue.async {
            logCtx("Task \(i) started")
            // Random sleep to show out-of-order execution
            let delay = Double.random(in: 0.05...0.2)
            Thread.sleep(forTimeInterval: delay)
            logCtx("Task \(i) finished (slept for \(String(format: "%.2f", delay)) s)")
            group.leave()
        }
    }

    group.notify(queue: .main) {
        logCtx("All tasks have finished. Note the order of completion may not match the order of submission!")
    }
}
