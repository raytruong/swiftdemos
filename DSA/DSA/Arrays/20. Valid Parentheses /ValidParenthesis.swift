import Playgrounds

struct ValidParenthesis {
    static let pairings: [Character: Character] = [
        "(" : ")",
        "{" : "}",
        "[" : "]",
    ]

    static func stack(_ s: String) -> Bool {
        var stack: [Character] = []
        for char in s {
            if isOpeningParen(char) {
                stack.append(char)
            }
            else {
                guard let lastOpening = stack.popLast() else {
                    return false
                }
                guard isValidPairing(opening: lastOpening, close: char) else {
                    return false
                }
            }
        }
        return stack.isEmpty
    }

    private static func isOpeningParen(_ char: Character) -> Bool {
        return pairings[char] != nil
    }

    private static func isValidPairing(opening: Character, close: Character) -> Bool {
        return pairings[opening] == close
    }
}


#Playground {
    print(ValidParenthesis.stack("()[{}]"))
}
