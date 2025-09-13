import Foundation
import Playgrounds

#Playground {
    // Demo: Serial queue executes tasks in strict order
    let serialQueue = DispatchQueue(label: "com.example.serialQueue")

    for i in 1...4 {
        serialQueue.async {
            print("Task \(i) started")
            Thread.sleep(forTimeInterval: 0.1) // Simulate some work
            print("Task \(i) finished")
        }
    }

    serialQueue.async {
        print("All tasks submitted to serial queue have finished in order.")
    }
}
