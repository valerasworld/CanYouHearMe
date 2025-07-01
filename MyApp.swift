import SwiftUI

@main
struct MyApp: App {
    
    @State var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: $viewModel)
                .preferredColorScheme(.dark)
                .environment(viewModel)
        }
    }
}
