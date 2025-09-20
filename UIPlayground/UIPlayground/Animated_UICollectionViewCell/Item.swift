import Foundation

nonisolated class Item: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    var isExpanded: Bool

    init(title: String, subtitle: String, isExpanded: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.isExpanded = isExpanded
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
