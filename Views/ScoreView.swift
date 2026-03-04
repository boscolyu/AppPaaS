import SwiftUI

struct ScoreView: View {
    @Bindable var viewModel: RoundViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단: 홀 정보
            headerSection
            
            Divider()
            
            // 중앙: 현재 홀 타수
            scoreSection
            
            Spacer()
            
            // 하단: 버튼들
            buttonSection
            
            // 누적 타수
            totalSection
        }
        .navigationTitle(viewModel.currentRound?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("홈") {
                    dismiss()
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.showStats) {
            StatsView(viewModel: viewModel)
        }
    }
    
    // MARK: - 상단 헤더
    
    private var headerSection: some View {
        HStack {
            Text("Hole \(viewModel.currentRound?.currentHoleNumber ?? 1)")
                .font(.title.bold())
            Text("/ 18")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - 타수 표시
    
    private var scoreSection: some View {
        VStack(spacing: 16) {
            // 총 타수
            Text("\(viewModel.currentHole?.totalStrokes ?? 0)")
                .font(.system(size: 80, weight: .bold, design: .rounded))
            
            Text("타")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            // 타입별 카운트
            HStack(spacing: 32) {
                shotCount(label: "정타", count: viewModel.currentHole?.normalCount ?? 0, color: .green)
                shotCount(label: "OB", count: viewModel.currentHole?.obCount ?? 0, color: .red)
                shotCount(label: "패널티", count: viewModel.currentHole?.penaltyCount ?? 0, color: .yellow)
            }
        }
        .padding(.top, 32)
    }
    
    private func shotCount(label: String, count: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2.bold())
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - 버튼
    
    private var buttonSection: some View {
        VStack(spacing: 12) {
            // 정타 / OB / 패널티
            HStack(spacing: 12) {
                shotButton(type: .normal, label: "정타", color: .green)
                shotButton(type: .ob, label: "OB", color: .red)
                shotButton(type: .penalty, label: "패널티", color: .yellow)
            }
            .padding(.horizontal, 16)
            
            // 실행취소 / 홀 종료
            HStack(spacing: 12) {
                Button {
                    viewModel.undoLastShot()
                } label: {
                    Text("실행취소")
                        .font(.body.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.gray.opacity(0.2))
                        .foregroundStyle(viewModel.canUndo ? .primary : .secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!viewModel.canUndo)
                
                Button {
                    viewModel.completeHole()
                } label: {
                    Text("홀 종료")
                        .font(.body.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
    }
    
    private func shotButton(type: ShotType, label: String, color: Color) -> some View {
        Button {
            viewModel.addShot(type: type)
        } label: {
            Text(label)
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(color)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    // MARK: - 누적 총 타수
    
    private var totalSection: some View {
        HStack {
            Text("누적")
                .foregroundStyle(.secondary)
            Spacer()
            Text("총 \(viewModel.currentRound?.totalStrokes ?? 0)타")
                .font(.headline)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
}
