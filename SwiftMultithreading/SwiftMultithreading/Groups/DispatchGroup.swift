import Foundation
import Playgrounds

#Playground {
    let group = DispatchGroup() // synchronization method - allows you to coordinate multiple tasks

    group.enter() // task started and added to group, group is now tracking

    group.leave() // task performed async work, finished, and left group

    group.wait() // wait for all tasks in the group (poll)

    group.notify(queue: DispatchQueue.main) { // on completion of all in group (signal)
        print("Group finished")
    }
}

