import Foundation

enum ShotType: String, Codable, CaseIterable {
    case normal  = "정타"
    case ob      = "OB"
    case penalty = "패널티"
}
