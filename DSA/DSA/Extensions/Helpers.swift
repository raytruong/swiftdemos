import Foundation

extension Collection where Element: Hashable {
    func unorderedEquals<C: Collection>(_ other: C) -> Bool where C.Element == Element {
        return Set(self) == Set(other)
    }
}
