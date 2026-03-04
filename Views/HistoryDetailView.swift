import SwiftUI

struct HistoryDetailView: View {
    let round: Round
    
    var body: some View {
        VStack(spacing: 0) {
            // 요약
            VStack(spacing: 8) {
                Text("\(round.totalStrokes)타")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                Text("정타 \(round.totalNormal) · OB \(round.totalOB) · 패널티 \(round.totalPenalty)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(round.date.formatted(date: .long, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 20)
            
            Divider()
            
            // 홀별 통계 테이블
            ScrollView {
                VStack(spacing: 0) {
                    // 헤더
                    HStack {
                        Text("홀").frame(width: 40, alignment: .center)
                        Text("정타").frame(maxWidth: .infinity)
                        Text("OB").frame(maxWidth: .infinity)
                        Text("패널티").frame(maxWidth: .infinity)
                        Text("합계").frame(maxWidth: .infinity)
                    }
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    
                    Divider()
                    
                    ForEach(round.sortedHoles, id: \.id) { hole in
                        HStack {
                            Text("\(hole.number)")
                                .frame(width: 40, alignment: .center)
                                .fontWeight(.medium)
                            Text("\(hole.normalCount)")
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.green)
                            Text("\(hole.obCount)")
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.red)
                            Text("\(hole.penaltyCount)")
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.orange)
                            Text("\(hole.totalStrokes)")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                        }
                        .font(.body)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        
                        Divider()
                    }
                }
            }
        }
        .navigationTitle(round.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
