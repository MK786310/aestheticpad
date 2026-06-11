import SwiftUI

/// Main entry point for the AestheticPad application
@main
struct AestheticPadApp: App {
    // MARK: - Properties
    
    @StateObject private var storeKitManager = StoreKitManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var userDefaultsManager = UserDefaultsManager.shared
    
    @State private var showOnboarding = false
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showOnboarding {
                    OnboardingView(isPresented: $showOnboarding)
                } else {
                    ContentView()
                        .environmentObject(storeKitManager)
                        .environmentObject(themeManager)
                        .environmentObject(userDefaultsManager)
                }
            }
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
            .onAppear {
                showOnboarding = !userDefaultsManager.hasCompletedOnboarding
                Task {
                    await storeKitManager.fetchProducts()
                }
            }
        }
    }
}
