import Foundation
import SwiftData
import Observation

@Observable
class HistoryViewModel {
    var rounds: [Round] = []
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadRounds()
    }
    
    func loadRounds() {
        let descriptor = FetchDescriptor<Round>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        rounds = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func deleteRound(_ round: Round) {
        modelContext.delete(round)
        try? modelContext.save()
        loadRounds()
    }
    
    var inProgressRound: Round? {
        rounds.first { !$0.isCompleted }
    }
}
