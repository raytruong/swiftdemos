import Testing

@testable import DSA

struct Number_of_Islands_Tests {
    @Test func basic_test_case() async throws {
        let input: [[Character]] = [["1","1","1","1","0"],["1","1","0","1","0"],["1","1","0","0","0"],["0","0","0","0","0"]]
        #expect(NumberOfIslands.dfs(input) == 1)
    }

    @Test func multiple_islands() async throws {
        let input: [[Character]] = [
            ["1","1","0","0","0"],
            ["1","1","0","0","0"],
            ["0","0","1","0","0"],
            ["0","0","0","1","1"]
        ]
        #expect(NumberOfIslands.dfs(input) == 3)
    }

    @Test func all_water() async throws {
        let input: [[Character]] = [
            ["0","0","0"],
            ["0","0","0"],
            ["0","0","0"]
        ]
        #expect(NumberOfIslands.dfs(input) == 0)
    }

    @Test func all_land() async throws {
        let input: [[Character]] = [
            ["1","1"],
            ["1","1"]
        ]
        #expect(NumberOfIslands.dfs(input) == 1)
    }

    @Test func single_row() async throws {
        let input: [[Character]] = [["1","0","1","0","1"]]
        #expect(NumberOfIslands.dfs(input) == 3)
    }

    @Test func single_column() async throws {
        let input: [[Character]] = [["1"],["0"],["1"],["1"],["0"]]
        #expect(NumberOfIslands.dfs(input) == 2)
    }

    @Test func one_cell_land() async throws {
        let input: [[Character]] = [["1"]]
        #expect(NumberOfIslands.dfs(input) == 1)
    }

    @Test func one_cell_water() async throws {
        let input: [[Character]] = [["0"]]
        #expect(NumberOfIslands.dfs(input) == 0)
    }
}
