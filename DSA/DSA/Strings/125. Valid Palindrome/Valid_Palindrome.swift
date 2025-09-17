import Playgrounds

struct ValidPalindrome {
    static func stringManipulation(_ s: String) -> Bool {
        let cleanedString = s.lowercased().filter { $0.isLetter || $0.isNumber }
        return Array(cleanedString) == cleanedString.reversed()
    }
}

#Playground {
    print(ValidPalindrome.stringManipulation("racecar"))
}
