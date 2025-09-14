import Foundation
import Playgrounds

#Playground {
    func mainThreadSyncDeadlock() {
        logCtx("About to deadlock on main queue...")
        DispatchQueue.main.sync { // main thread is halted.
            logCtx("This will never logCtx")
        }
    }

    func selfReferentialDeadlock() {
        let q1 = DispatchQueue(label: "q1")
        logCtx("simulating deadlock")
        q1.async {
            logCtx("Task 1 started")
            Thread.sleep(forTimeInterval: 0.1) // Simulate some work
            q1.sync { // q1 is halted.
                // This will never execute, since q1 is halted
                logCtx("Task 2 started")
                Thread.sleep(forTimeInterval: 0.1)
                logCtx("Task 2 finished")
            }
            logCtx("Task 1 finished")
        }
    }

    func barrierDeadlock() {
        let q1 = DispatchQueue(label: "q1", attributes: .concurrent)
        q1.async {
            logCtx("Task 1 started")
            Thread.sleep(forTimeInterval: 0.2) // Simulate some work
            q1.sync(flags: .barrier) { // halts  q1, despite it being concurrent
                logCtx("Task 2 started")
                Thread.sleep(forTimeInterval: 0.1)
                logCtx("Task 2 finished")
            }
            logCtx("Task 1 finished")
        }
    }

    selfReferentialDeadlock()
}
