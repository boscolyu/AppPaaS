import Foundation
import SwiftData

@Model
class Round {
    var id: UUID = UUID()
    var name: String = ""
    var date: Date = Date()
    var isCompleted: Bool = false
    var currentHoleNumber: Int = 1
    
    @Relationship(deleteRule: .cascade, inverse: \Hole.round)
    var holes: [Hole] = []
    
    var totalStrokes: Int {
        holes.reduce(0) { $0 + $1.totalStrokes }
    }
    
    var totalNormal: Int {
        holes.reduce(0) { $0 + $1.normalCount }
    }
    
    var totalOB: Int {
        holes.reduce(0) { $0 + $1.obCount }
    }
    
    var totalPenalty: Int {
        holes.reduce(0) { $0 + $1.penaltyCount }
    }
    
    var currentHole: Hole? {
        holes.first { $0.number == currentHoleNumber }
    }
    
    var sortedHoles: [Hole] {
        holes.sorted { $0.number < $1.number }
    }
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.date = Date()
    }
}
