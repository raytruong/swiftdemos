import Playgrounds

// This example shows how actor reentrancy can lead to a bug
// Task 1 and Task 2 are not guaranteed execution ordering

actor UserActor {
    var name: String?
    
    func setName(name: String) async {
        // Simulate a network call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        self.name = name
        print("Task 1: Name set to \(name)")
    }
    
    func printName() {
        if let name = self.name {
            print("Task 2: User name is \(name)")
        } else {
            print("Task 2: Name not yet available.")
            
        }
    }
}

#Playground {
    let userActor = UserActor()

    // These two tasks run independently and the order of their completion is not guaranteed.
    Task { await userActor.setName(name: "Alice") }
    Task { await userActor.printName() }

    // This task runs each step in structured order. This is similar to a critical section.
    Task {
        await userActor.setName(name: "Alice")
        await userActor.printName()
    }
}
