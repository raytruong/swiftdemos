import Testing

@testable import DSA

struct Letter_Combinations_Tests {
    @Test func basic_test_case() async throws {
        let expected = ["ad","ae","af","bd","be","bf","cd","ce","cf"]
        #expect(LetterCombinations.backtracking("23") == expected)
    }

    @Test func empty_input_returns_empty_array() async throws {
        let expected: [String] = []
        #expect(LetterCombinations.backtracking("") == expected)
    }

    @Test func single_digit() async throws {
        let expected = ["a","b","c"]
        #expect(LetterCombinations.backtracking("2") == expected)
    }

    @Test func two_digits_seven_and_nine() async throws {
        let expected = [
            "pw", "px", "py", "pz",
            "qw", "qx", "qy", "qz",
            "rw", "rx", "ry", "rz",
            "sw", "sx", "sy", "sz"
        ]
        #expect(LetterCombinations.backtracking("79") == expected)
    }

    @Test func three_digits() async throws {
        let expected = [
            "adg", "adh", "adi", "aeg", "aeh", "aei", "afg", "afh", "afi",
            "bdg", "bdh", "bdi", "beg", "beh", "bei", "bfg", "bfh", "bfi",
            "cdg", "cdh", "cdi", "ceg", "ceh", "cei", "cfg", "cfh", "cfi"
        ]
        #expect(LetterCombinations.backtracking("234") == expected)
    }
}
