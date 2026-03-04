import Foundation
import SwiftData
import Observation

@Observable
class RoundViewModel {
    var currentRound: Round?
    var showStats: Bool = false
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    var currentHole: Hole? {
        currentRound?.currentHole
    }
    
    var canUndo: Bool {
        guard let hole = currentHole else { return false }
        return !hole.shots.isEmpty
    }
    
    var isLastHole: Bool {
        currentRound?.currentHoleNumber == 18
    }
    
    // MARK: - 라운딩 시작
    
    func startRound(name: String) {
        let roundName = name.trimmingCharacters(in: .whitespaces).isEmpty
            ? defaultRoundName()
            : name
        
        let round = Round(name: roundName)
        let firstHole = Hole(number: 1)
        round.holes.append(firstHole)
        
        modelContext.insert(round)
        save()
        
        currentRound = round
    }
    
    // MARK: - 타 기록
    
    func addShot(type: ShotType) {
        guard let hole = currentHole else { return }
        
        let shot = Shot(type: type)
        hole.shots.append(shot)
        save()
    }
    
    // MARK: - 실행취소
    
    func undoLastShot() {
        guard let hole = currentHole else { return }
        guard let lastShot = hole.shots.sorted(by: { $0.timestamp < $1.timestamp }).last else { return }
        
        hole.shots.removeAll { $0.id == lastShot.id }
        modelContext.delete(lastShot)
        save()
    }
    
    // MARK: - 홀 전환
    
    func completeHole() {
        guard let hole = currentHole else { return }
        hole.isCompleted = true
        save()
        showStats = true
    }
    
    func moveToNextHole() {
        guard let round = currentRound else { return }
        
        let nextNumber = round.currentHoleNumber + 1
        let newHole = Hole(number: nextNumber)
        round.holes.append(newHole)
        round.currentHoleNumber = nextNumber
        save()
        
        showStats = false
    }
    
    // MARK: - 라운딩 완료
    
    func completeRound() {
        guard let round = currentRound else { return }
        round.isCompleted = true
        save()
    }
    
    // MARK: - 진행 중 라운딩 복원
    
    func resumeRound(_ round: Round) {
        currentRound = round
    }
    
    // MARK: - Private
    
    private func save() {
        try? modelContext.save()
    }
    
    private func defaultRoundName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "\(formatter.string(from: Date())) 라운딩"
    }
}
