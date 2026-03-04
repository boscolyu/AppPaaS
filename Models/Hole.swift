import Foundation
import SwiftData

@Model
class Hole {
    var id: UUID = UUID()
    var number: Int = 1
    var isCompleted: Bool = false
    
    @Relationship(deleteRule: .cascade, inverse: \Shot.hole)
    var shots: [Shot] = []
    
    var round: Round?
    
    var totalStrokes: Int {
        shots.count
    }
    
    var normalCount: Int {
        shots.filter { $0.type == .normal }.count
    }
    
    var obCount: Int {
        shots.filter { $0.type == .ob }.count
    }
    
    var penaltyCount: Int {
        shots.filter { $0.type == .penalty }.count
    }
    
    init(number: Int) {
        self.id = UUID()
        self.number = number
    }
}
