import Foundation

enum ComputationQOS: String, CaseIterable, Identifiable {
    case userInteractive
    case userInitiated
    case utility
    case background

    var id: String { rawValue }

    var description: String {
        switch self {
        case .userInteractive: return "User Interactive"
        case .userInitiated: return "User Initiated"
        case .utility: return "Utility"
        case .background: return "Background"
        }
    }

    var qosClass: DispatchQoS.QoSClass {
        switch self {
        case .userInteractive: return .userInteractive
        case .userInitiated: return .userInitiated
        case .utility: return .utility
        case .background: return .background
        }
    }
}

struct ComputationHistoryEntry: Identifiable {
    var id = UUID()
    let qos: ComputationQOS
    var isCompleted: Bool
    var duration: Double?
    let enqueueTimestamp: Date
}
