import SwiftUI

@main struct App: SwiftUI.App {
    @StateObject var store = Store()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(self.store)
        }
    }
}
