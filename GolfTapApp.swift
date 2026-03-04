import SwiftUI
import SwiftData

@main
struct GolfTapApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [Round.self, Hole.self, Shot.self])
    }
}
