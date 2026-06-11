import SwiftUI

struct SettingsTabView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var storeKitManager: StoreKitManager
    @State private var showPremiumSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                // Subscription Section
                Section("Subscription") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Premium Status")
                            Spacer()
                            Text(viewModel.subscriptionStatus.displayText)
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        
                        if !viewModel.isPremium {
                            Button(action: { showPremiumSheet = true }) {
                                Text("Upgrade to Premium")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            Button(action: { viewModel.restorePurchases() }) {
                                Text("Restore Purchases")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                
                // App Settings Section
                Section("App Settings") {
                    NavigationLink(destination: AppearanceSettingsView()) {
                        Label("Appearance", systemImage: "paintpalette.fill")
                    }
                    
                    NavigationLink(destination: NotificationSettingsView()) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    
                    NavigationLink(destination: StorageSettingsView()) {
                        Label("Storage", systemImage: "internaldrive.fill")
                    }
                }
                
                // Account Section
                Section("Account") {
                    Button(action: { viewModel.sendFeedback() }) {
                        Label("Send Feedback", systemImage: "envelope.fill")
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: { viewModel.openPrivacyPolicy() }) {
                        Label("Privacy Policy", systemImage: "lock.fill")
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: { viewModel.openTermsOfService() }) {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                            .foregroundColor(.primary)
                    }
                }
                
                // About Section
                Section("About") {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text(viewModel.appVersion)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Build Number")
                        Spacer()
                        Text(viewModel.appBuild)
                            .foregroundColor(.gray)
                    }
                }
                
                // Danger Zone
                Section("Danger Zone") {
                    Button(action: { viewModel.clearAppData() }) {
                        Text("Clear All Data")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPremiumSheet) {
                PremiumSheetView(isPresented: $showPremiumSheet)
                    .environmentObject(storeKitManager)
            }
        }
    }
}

struct AppearanceSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        List {
            Section("Theme") {
                Picker("Color Scheme", selection: $themeManager.currentTheme) {
                    ForEach(themeManager.allThemes, id: \.id) { theme in
                        HStack {
                            Circle().fill(theme.primaryColor).frame(width: 16, height: 16)
                            Text(theme.name).tag(theme)
                        }
                    }
                }
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationSettingsView: View {
    @State private var enableNotifications = true
    @State private var enableSoundEffects = true
    @State private var enableHaptics = true
    
    var body: some View {
        List {
            Section("Notifications") {
                Toggle("Enable Notifications", isOn: $enableNotifications)
                Toggle("Sound Effects", isOn: $enableSoundEffects)
                Toggle("Haptics", isOn: $enableHaptics)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StorageSettingsView: View {
    @State private var cacheSize = "245 MB"
    @State private var showClearCache = false
    
    var body: some View {
        List {
            Section("Storage") {
                HStack {
                    Text("Cache Size")
                    Spacer()
                    Text(cacheSize)
                        .foregroundColor(.gray)
                }
                
                Button(action: { showClearCache = true }) {
                    Text("Clear Cache")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Storage")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Clear Cache?", isPresented: $showClearCache) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                cacheSize = "0 MB"
            }
        } message: {
            Text("This will clear cached data and free up space.")
        }
    }
}

struct PremiumSheetView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var storeKitManager: StoreKitManager
    @State private var selectedTier = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        Text("AestheticPad Premium")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Unlock unlimited creativity")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(PremiumFeature.allCases, id: \.self) { feature in
                            HStack(spacing: 12) {
                                Image(systemName: feature.icon)
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(feature.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(feature.description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Pricing
                    VStack(spacing: 12) {
                        ForEach(SubscriptionTier.all, id: \.id) { tier in
                            PricingOptionView(
                                tier: tier,
                                isSelected: selectedTier == tier.id,
                                onSelect: { selectedTier = tier.id },
                                onPurchase: { purchaseTier(tier) }
                            )
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { isPresented = false }
                }
            }
        }
    }
    
    private func purchaseTier(_ tier: SubscriptionTier) {
        Task {
            if tier.isYearly, let product = storeKitManager.yearlyProduct {
                await storeKitManager.purchase(product)
            } else if !tier.isYearly, let product = storeKitManager.monthlyProduct {
                await storeKitManager.purchase(product)
            }
        }
    }
}

struct PricingOptionView: View {
    let tier: SubscriptionTier
    let isSelected: Bool
    let onSelect: () -> Void
    let onPurchase: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(tier.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    HStack(spacing: 8) {
                        Text(tier.price)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text(tier.billingPeriod)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if let savings = tier.savingsPercentage {
                    VStack {
                        Text("Save")
                            .font(.caption2)
                        Text("\(savings)%")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(6)
                }
            }
            
            Button(action: onPurchase) {
                Text("Subscribe Now")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .onTapGesture(perform: onSelect)
    }
}

#Preview {
    SettingsTabView()
        .environmentObject(StoreKitManager.shared)
        .environmentObject(ThemeManager.shared)
}
