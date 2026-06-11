import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentStep = 0
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Steps
                TabView(selection: $currentStep) {
                    OnboardingStep1().tag(0)
                    OnboardingStep2().tag(1)
                    OnboardingStep3().tag(2)
                    OnboardingStep4().tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                // Navigation
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { index in
                            Capsule()
                                .fill(currentStep == index ? Color.blue : Color.gray.opacity(0.3))
                                .frame(height: 6)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        if currentStep > 0 {
                            Button(action: { withAnimation { currentStep -= 1 } }) {
                                Text("Back")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        if currentStep < 3 {
                            Button(action: { withAnimation { currentStep += 1 } }) {
                                Text("Next")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            Button(action: completeOnboarding) {
                                Text("Get Started")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private func completeOnboarding() {
        userDefaultsManager.hasCompletedOnboarding = true
        withAnimation {
            isPresented = false
        }
    }
}

struct OnboardingStep1: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 8) {
                Text("Welcome to AestheticPad")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Create beautiful wallpapers, themes, and more")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingStep2: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundColor(.purple)
            
            VStack(spacing: 16) {
                Text("Create Custom Wallpapers")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(icon: "gradient", title: "Beautiful Gradients", description: "Mix and match colors")
                    FeatureRow(icon: "textformat", title: "Add Text", description: "Personalize with messages")
                    FeatureRow(icon: "sparkles", title: "Use Stickers", description: "Emoji and custom stickers")
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingStep3: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            VStack(spacing: 16) {
                Text("Design Widgets")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(icon: "paintpalette.fill", title: "Customize Colors", description: "Match your style")
                    FeatureRow(icon: "square.grid.2x2", title: "Choose Sizes", description: "Small, medium, or large")
                    FeatureRow(icon: "book.fill", title: "Setup Guides", description: "Easy installation")
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingStep4: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "crown.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            VStack(spacing: 16) {
                Text("Go Premium")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Unlock exclusive features and content")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 8) {
                    FeatureRow(icon: "sparkles", title: "Exclusive Wallpapers", description: "Premium collections")
                    FeatureRow(icon: "infinity", title: "Unlimited Themes", description: "Save as many as you want")
                    FeatureRow(icon: "icloud.fill", title: "Cloud Sync", description: "Access everywhere")
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
        .environmentObject(UserDefaultsManager.shared)
}
