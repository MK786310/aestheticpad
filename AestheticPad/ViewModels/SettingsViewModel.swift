import Foundation
import Combine
import SwiftUI

/// View model for settings
@MainActor
class SettingsViewModel: ObservableObject {
    @Published var appVersion = Constants.appVersion
    @Published var appBuild = Constants.appBuild
    @Published var isPremium = false
    @Published var subscriptionStatus: SubscriptionStatus = .loading
    @Published var showAbout = false
    @Published var showPrivacy = false
    @Published var isLoading = false
    
    private let storeKitManager = StoreKitManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        checkSubscriptionStatus()
    }
    
    func checkSubscriptionStatus() {
        Task {
            await storeKitManager.checkSubscriptionStatus()
        }
    }
    
    func restorePurchases() {
        Task {
            await storeKitManager.restorePurchases()
        }
    }
    
    func clearAppData() {
        userDefaultsManager.clearAll()
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: Constants.privacyURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func openTermsOfService() {
        if let url = URL(string: Constants.termsURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func sendFeedback() {
        if let url = URL(string: "mailto:\(Constants.supportEmail)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func setupBindings() {
        storeKitManager.$subscriptionStatus
            .assign(to: &$subscriptionStatus)
        
        storeKitManager.$subscriptionStatus
            .map { status in
                if case .subscribed = status {
                    return true
                }
                return false
            }
            .assign(to: &$isPremium)
    }
}
