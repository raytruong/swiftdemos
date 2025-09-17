import Testing

@testable import DSA

struct Valid_Palindrome_Tests {
    @Test func basic_test_case() async throws {
        #expect(ValidPalindrome.stringManipulation("racecar") == true)
    }

    @Test func palindrome_with_spaces_and_punctuation() async throws {
        #expect(ValidPalindrome.stringManipulation("A man, a plan, a canal: Panama") == true)
    }

    @Test func mixed_case_palindrome() async throws {
        #expect(ValidPalindrome.stringManipulation("RaceCar") == true)
    }

    @Test func non_palindrome() async throws {
        #expect(ValidPalindrome.stringManipulation("hello") == false)
    }

    @Test func empty_string() async throws {
        #expect(ValidPalindrome.stringManipulation("") == true)
    }

    @Test func single_character() async throws {
        #expect(ValidPalindrome.stringManipulation("a") == true)
    }

    @Test func only_non_alphanumeric() async throws {
        #expect(ValidPalindrome.stringManipulation("!!!") == true)
    }
}
