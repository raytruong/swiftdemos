import Testing

@testable import DSA

struct Linked_List_Cycle_Tests {
    @Test func basic_test_case() async throws {
        let input = [3, 2, 0, -4]
        let nodes = input.map { ListNode($0) }
        for i in 0..<nodes.count where (nodes.indices.contains(i+1)) {
            nodes[i].next = nodes[i+1]
        }
        #expect(LinkedListCycle.iteration(nodes.first) == false)
    }

    @Test func cycle_to_head() async throws {
        let input = [1, 2, 3, 4, 5]
        let nodes = input.map { ListNode($0) }
        for i in 0..<(nodes.count-1) {
            nodes[i].next = nodes[i+1]
        }
        nodes.last?.next = nodes.first // cycle back to head
        #expect(LinkedListCycle.iteration(nodes.first) == true)
    }

    @Test func cycle_to_middle() async throws {
        let input = [1, 2, 3, 4, 5]
        let nodes = input.map { ListNode($0) }
        for i in 0..<(nodes.count-1) {
            nodes[i].next = nodes[i+1]
        }
        nodes.last?.next = nodes[2] // cycle back to node with value 3
        #expect(LinkedListCycle.iteration(nodes.first) == true)
    }

    @Test func single_node_no_cycle() async throws {
        let node = ListNode(42)
        #expect(LinkedListCycle.iteration(node) == false)
    }

    @Test func single_node_with_cycle() async throws {
        let node = ListNode(99)
        node.next = node
        #expect(LinkedListCycle.iteration(node) == true)
    }

    @Test func empty_list() async throws {
        #expect(LinkedListCycle.iteration(nil) == false)
    }
}
