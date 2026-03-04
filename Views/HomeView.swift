import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showNewRound = false
    @State private var roundName = ""
    @State private var navigateToScore = false
    @State private var roundVM: RoundViewModel?
    @State private var historyVM: HistoryViewModel?
    @State private var navigateToHistory = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                // 앱 타이틀
                VStack(spacing: 8) {
                    Text("⛳")
                        .font(.system(size: 64))
                    Text("GolfTap")
                        .font(.largeTitle.bold())
                    Text("간편 스코어 기록")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // 진행 중 라운딩 이어서 하기
                if let inProgress = historyVM?.inProgressRound {
                    Button {
                        let vm = RoundViewModel(modelContext: modelContext)
                        vm.resumeRound(inProgress)
                        roundVM = vm
                        navigateToScore = true
                    } label: {
                        VStack(spacing: 4) {
                            Text("이어서 하기")
                                .font(.headline)
                            Text("\(inProgress.name) · \(inProgress.currentHoleNumber)홀")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.orange)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                
                // 새 라운딩
                Button {
                    roundName = ""
                    showNewRound = true
                } label: {
                    Text("새 라운딩")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                
                // 히스토리
                Button {
                    navigateToHistory = true
                } label: {
                    Text("히스토리")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationDestination(isPresented: $navigateToScore) {
                if let vm = roundVM {
                    ScoreView(viewModel: vm)
                }
            }
            .navigationDestination(isPresented: $navigateToHistory) {
                HistoryView()
            }
            .alert("새 라운딩", isPresented: $showNewRound) {
                TextField("라운딩 이름 (예: 남서울CC)", text: $roundName)
                Button("시작") {
                    let vm = RoundViewModel(modelContext: modelContext)
                    vm.startRound(name: roundName)
                    roundVM = vm
                    navigateToScore = true
                }
                Button("취소", role: .cancel) {}
            } message: {
                Text("라운딩 이름을 입력하세요.\n비워두면 오늘 날짜로 생성됩니다.")
            }
            .onAppear {
                historyVM = HistoryViewModel(modelContext: modelContext)
            }
        }
    }
}
