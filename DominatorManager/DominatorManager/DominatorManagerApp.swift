import SwiftUI

@main
struct DominatorManagerApp: App {
    @StateObject private var viewModel = DeviceListViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
