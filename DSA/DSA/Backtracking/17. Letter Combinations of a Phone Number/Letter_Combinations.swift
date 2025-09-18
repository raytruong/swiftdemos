import Playgrounds

struct LetterCombinations {
    static let digitToLetters: [Character: [String]] = [
        "2": ["a", "b", "c"],
        "3": ["d", "e", "f"],
        "4": ["g", "h", "i"],
        "5": ["j", "k", "l"],
        "6": ["m", "n", "o"],
        "7": ["p", "q", "r", "s"],
        "8": ["t", "u", "v"],
        "9": ["w", "x", "y", "z"]
    ]

    static func backtracking(_ digits: String) -> [String] {
        var result: [String] = []

        func backtrack(remaining: ArraySlice<Character>, path: String) {
            guard let nextDigit = remaining.first else {
                if !path.isEmpty {
                    result.append(path)
                }
                return
            }

            let nextPossibleLetter = digitToLetters[nextDigit] ?? []

            for nextLetter in nextPossibleLetter {
                backtrack(
                    remaining: remaining.dropFirst(),
                    path: path + nextLetter
                )
            }
        }

        backtrack(remaining: ArraySlice(digits), path: "")
        return result
    }
}

#Playground {
    print(LetterCombinations.backtracking("23"))
}
