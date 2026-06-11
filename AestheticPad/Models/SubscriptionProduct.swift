import Foundation
import StoreKit

/// Represents an in-app subscription product
struct SubscriptionProduct: Identifiable {
    let id: String
    let product: Product
    
    var displayName: String { product.displayName }
    var displayPrice: String { product.displayPrice }
    var description: String { product.description }
    
    enum ProductType {
        case monthly
        case yearly
        
        var id: String {
            switch self {
            case .monthly: return "com.aestheticpad.premium.monthly"
            case .yearly: return "com.aestheticpad.premium.yearly"
            }
        }
    }
}

/// Subscription status
enum SubscriptionStatus: Equatable {
    case notSubscribed
    case subscribed(expiryDate: Date)
    case expired
    case loading
    case error(String)
    
    var isActive: Bool {
        if case .subscribed = self {
            return true
        }
        return false
    }
    
    var displayText: String {
        switch self {
        case .notSubscribed:
            return "Not subscribed"
        case .subscribed(let expiryDate):
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "Active until \(formatter.string(from: expiryDate))"
        case .expired:
            return "Subscription expired"
        case .loading:
            return "Loading..."
        case .error(let message):
            return "Error: \(message)"
        }
    }
}

/// Premium features
enum PremiumFeature: String, CaseIterable {
    case exclusiveWallpapers = "Exclusive Wallpaper Packs"
    case advancedWidgets = "Advanced Widget Templates"
    case unlimitedThemes = "Unlimited Saved Themes"
    case premiumFonts = "Premium Font Collections"
    case cloudSync = "Cloud Sync Support"
    case adFree = "Ad-Free Experience"
    
    var icon: String {
        switch self {
        case .exclusiveWallpapers: return "sparkles"
        case .advancedWidgets: return "square.grid.2x2"
        case .unlimitedThemes: return "paintpalette.fill"
        case .premiumFonts: return "textformat"
        case .cloudSync: return "icloud.fill"
        case .adFree: return "xmark.circle.fill"
        }
    }
    
    var description: String {
        switch self {
        case .exclusiveWallpapers:
            return "Access to premium wallpaper collections"
        case .advancedWidgets:
            return "Professional widget templates"
        case .unlimitedThemes:
            return "Save unlimited custom themes"
        case .premiumFonts:
            return "Curated premium font collections"
        case .cloudSync:
            return "Sync your creations across devices"
        case .adFree:
            return "Enjoy an ad-free experience"
        }
    }
}

/// Subscription tier information
struct SubscriptionTier: Identifiable {
    let id: String
    let name: String
    let price: String
    let billingPeriod: String
    let features: [PremiumFeature]
    let isYearly: Bool
    let savingsPercentage: Int?
    
    static let monthly = SubscriptionTier(
        id: "monthly",
        name: "Monthly",
        price: "$4.99",
        billingPeriod: "per month",
        features: PremiumFeature.allCases,
        isYearly: false,
        savingsPercentage: nil
    )
    
    static let yearly = SubscriptionTier(
        id: "yearly",
        name: "Yearly",
        price: "$39.99",
        billingPeriod: "per year",
        features: PremiumFeature.allCases,
        isYearly: true,
        savingsPercentage: 33
    )
    
    static let all = [monthly, yearly]
}
