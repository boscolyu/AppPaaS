import SwiftUI

struct StatsView: View {
    @Bindable var viewModel: RoundViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToHome = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 제목
            Text(viewModel.isLastHole && viewModel.currentHole?.isCompleted == true
                 ? "🎉 라운딩 완료!" : "홀 \(viewModel.currentRound?.currentHoleNumber ?? 1) 완료")
                .font(.title2.bold())
                .padding(.top, 20)
            
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
                    
                    // 홀별 데이터
                    if let round = viewModel.currentRound {
                        ForEach(round.sortedHoles.filter { $0.isCompleted }, id: \.id) { hole in
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
            
            Divider()
            
            // 총 합계
            if let round = viewModel.currentRound {
                HStack {
                    Text("총 합계")
                        .fontWeight(.bold)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(round.totalStrokes)타")
                            .font(.title.bold())
                        Text("정타 \(round.totalNormal) · OB \(round.totalOB) · 패널티 \(round.totalPenalty)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            
            // 다음 홀 / 라운딩 완료 버튼
            if viewModel.isLastHole && viewModel.currentHole?.isCompleted == true {
                Button {
                    viewModel.completeRound()
                    // 홈으로 돌아가기: NavigationStack의 루트로
                    dismiss()
                    dismiss()
                } label: {
                    Text("홈으로 돌아가기")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            } else {
                Button {
                    viewModel.moveToNextHole()
                    dismiss()
                } label: {
                    Text("다음 홀 →")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
