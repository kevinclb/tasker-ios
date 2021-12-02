import SwiftUI
import Firebase

@main
struct DevelopmentEnvironmentApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
