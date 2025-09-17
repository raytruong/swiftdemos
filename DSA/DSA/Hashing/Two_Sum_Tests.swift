import Testing

@testable import DSA

struct Two_Sum_Tests {
    @Test func bruteforce() async throws {
        let input = [2,7,11,15]
        let target = 9
        #expect(TwoSum.bruteforce(input, target).unorderedEquals([0, 1]))
    }

    @Test func dictionary() async throws {
        let input = [2,7,11,15]
        let target = 9
        #expect(TwoSum.dictionary(input, target).unorderedEquals([0, 1]))
    }
}
