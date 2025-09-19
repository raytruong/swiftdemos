import Playgrounds

nonisolated class ListNode {
    var val: Int
    var next: ListNode?

    init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

struct LinkedListCycle {
    static func iteration(_ head: ListNode?) -> Bool {
        if head == nil { return false }
        var cursor: ListNode? = head
        while cursor != nil {
            if cursor?.val == Int.max {
                return true
            }
            else {
                cursor?.val = Int.max // mark as seen, and continue walking the list
                cursor = cursor?.next
            }
        }
        return false
    }
}

#Playground {
    // Set up the list
    let input = [3, 2, 0, -4]
    let nodes = input.map { ListNode($0) }
    for i in 0..<nodes.count where (nodes.indices.contains(i+1)) {
        nodes[i].next = nodes[i+1]
    }
    print(LinkedListCycle.iteration(nodes.first))
}
