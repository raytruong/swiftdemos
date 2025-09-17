import Testing

@testable import DSA

struct Two_Sum_Tests {
    @Test func basic_test_case() async throws {
        let input = [2,7,11,15]
        let target = 9
        #expect(TwoSum.bruteforce(input, target).unorderedEquals([0, 1]))
        #expect(TwoSum.dictionary(input, target).unorderedEquals([0, 1]))
    }

    @Test func negative_numbers() async throws {
        let input = [-3, 4, 3, 90]
        let target = 0
        #expect(TwoSum.bruteforce(input, target).unorderedEquals([0, 2]))
        #expect(TwoSum.dictionary(input, target).unorderedEquals([0, 2]))
    }

    @Test func no_solution() async throws {
        let input = [1, 2, 3, 4]
        let target = 8
        #expect(TwoSum.bruteforce(input, target).isEmpty)
        #expect(TwoSum.dictionary(input, target).isEmpty)
    }

    @Test func duplicate_elements() async throws {
        let input = [3, 3]
        let target = 6
        #expect(TwoSum.bruteforce(input, target).unorderedEquals([0, 1]))
        #expect(TwoSum.dictionary(input, target).unorderedEquals([0, 1]))
    }

    @Test func minimal_input() async throws {
        let input = [1, 2]
        let target = 3
        #expect(TwoSum.bruteforce(input, target).unorderedEquals([0, 1]))
        #expect(TwoSum.dictionary(input, target).unorderedEquals([0, 1]))
    }
}
