import Foundation

extension Collection where Element: Hashable {
    func unorderedEquals<C: Collection>(_ other: C) -> Bool where C.Element == Element {
        return Set(self) == Set(other)
    }
}

extension Collection {
    /// Safely access an element by index. Returns the element if the index exists, otherwise nil.
    subscript(safe index: Index) -> Element? {
        guard index >= startIndex, index < endIndex else { return nil }
        return self[index]
    }
}
