import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: HistoryViewModel?
    @State private var showDeleteAlert = false
    @State private var roundToDelete: Round?
    
    var body: some View {
        Group {
            if let vm = viewModel {
                if vm.rounds.isEmpty {
                    ContentUnavailableView(
                        "기록이 없습니다",
                        systemImage: "flag.fill",
                        description: Text("새 라운딩을 시작해보세요!")
                    )
                } else {
                    List {
                        ForEach(vm.rounds, id: \.id) { round in
                            NavigationLink {
                                HistoryDetailView(round: round)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(round.name)
                                                .font(.headline)
                                            if !round.isCompleted {
                                                Text("진행 중")
                                                    .font(.caption2)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(.orange)
                                                    .foregroundStyle(.white)
                                                    .clipShape(Capsule())
                                            }
                                        }
                                        Text(round.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("\(round.totalStrokes)타")
                                        .font(.title3.bold())
                                }
                            }
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                roundToDelete = vm.rounds[index]
                                showDeleteAlert = true
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("히스토리")
        .alert("라운딩 삭제", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                if let round = roundToDelete {
                    viewModel?.deleteRound(round)
                }
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("'\(roundToDelete?.name ?? "")'을(를) 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.")
        }
        .onAppear {
            if viewModel == nil {
                viewModel = HistoryViewModel(modelContext: modelContext)
            } else {
                viewModel?.loadRounds()
            }
        }
    }
}
