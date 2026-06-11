# StoreKit 2 Testing Guide

## Overview

AestheticPad uses StoreKit 2 for managing subscriptions. This guide explains how to test in-app purchases locally.

## Local Testing with StoreKit Config File

### Step 1: Add StoreKit Configuration

1. In Xcode, go to **File → New → File**
2. Choose **StoreKit Configuration File**
3. Name it `StoreKitConfig.storekit`
4. Add to **AestheticPad** target

### Step 2: Configure Products

Add the following products to your `.storekit` file:

#### Monthly Subscription

```
Product ID: com.aestheticpad.premium.monthly
Type: Auto-Renewable Subscription
Display Name: Monthly Premium
Price: $4.99
Billing Period: Monthly
Family Shareable: No
```

#### Yearly Subscription

```
Product ID: com.aestheticpad.premium.yearly
Type: Auto-Renewable Subscription
Display Name: Yearly Premium
Price: $39.99
Billing Period: Yearly
Family Shareable: No
```

### Step 3: Run in Simulator

1. Select **iPad** simulator
2. Go to **Product → Scheme → Edit Scheme**
3. Select **Run** tab
4. Under **StoreKit Configuration**: Select your `.storekit` file
5. Build and run: **Cmd + R**

## Testing Scenarios

### Test Purchase Flow

1. Navigate to **Settings → Premium**
2. Tap **Subscribe Now** for monthly/yearly
3. Confirm purchase (no charge in sandbox)
4. Verify subscription status updates

### Test Subscription Validation

```swift
// In StoreKitManager
await storeKitManager.checkSubscriptionStatus()
// Subscription status should update
```

### Test Purchase Restoration

1. Make a purchase
2. Delete and reinstall the app
3. Navigate to **Settings**
4. Tap **Restore Purchases**
5. Previous subscription should be restored

### Test Expired Subscription

In `.storekit` file, set subscription to:
- Expires after: 1 minute
- Wait 2 minutes
- Verify status changes to `.expired`

## Sandbox Testing

### Create Test Account

1. Go to **App Store Connect**
2. **Users and Access → Sandbox → Testers**
3. Add new tester with test email
4. Password: Any password you want

### Test on Device

1. Go to **Settings → App Store**
2. Tap your Apple ID
3. Sign out
4. Sign in with sandbox tester account
5. Install app on device
6. Test purchases (no actual charges)

## Debugging

### View StoreKit Logs

```bash
# In Xcode console, enable debug logging
defaults write com.apple.dt.Xcode IDESourceTreeDisplayNames -dict-add STOREKIT_DEBUG 1
```

### Common Issues

#### "No products found"

- Verify product IDs match exactly in code and `.storekit` file
- Check `.storekit` file is added to target
- Rebuild project

#### "Transaction verification failed"

- Ensure running with StoreKit configuration
- Check subscription validity dates
- Clear build folder: **Cmd + Shift + K**

#### Purchases don't persist

- Check UserDefaults implementation
- Verify `transaction.finish()` is called
- Ensure `@MainActor` annotations are present

## Production Configuration

### App Store Connect Setup

1. Create App ID with In-App Purchase capability
2. Add subscription products:
   - `com.aestheticpad.premium.monthly`
   - `com.aestheticpad.premium.yearly`
3. Set pricing tiers
4. Configure subscription duration

### Code Changes for Production

1. Remove `.storekit` file from project
2. Products will be fetched from App Store Connect
3. No code changes needed - StoreKit handles this

## Testing Checklist

- [ ] Products display correctly
- [ ] Purchase flow completes
- [ ] Subscription status updates
- [ ] Expired subscription detected
- [ ] Premium features unlock after purchase
- [ ] Restore purchases works
- [ ] App relaunches with active subscription
- [ ] Error handling works for failed purchases
- [ ] UI updates immediately after purchase
- [ ] Transaction finish is called

## References

- [Apple StoreKit 2 Documentation](https://developer.apple.com/documentation/storekit)
- [Testing In-App Purchases](https://developer.apple.com/documentation/storekit/testing_in-app_purchases_in_xcode)
- [App Store Connect Help](https://help.apple.com/app-store-connect)

---

**Questions? Check Apple's official documentation or GitHub issues.**
