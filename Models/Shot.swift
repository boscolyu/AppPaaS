import Foundation
import SwiftData

@Model
class Shot {
    var id: UUID = UUID()
    var typeRaw: String = ShotType.normal.rawValue
    var timestamp: Date = Date()
    
    var hole: Hole?
    
    var type: ShotType {
        get { ShotType(rawValue: typeRaw) ?? .normal }
        set { typeRaw = newValue.rawValue }
    }
    
    init(type: ShotType) {
        self.id = UUID()
        self.typeRaw = type.rawValue
        self.timestamp = Date()
    }
}
