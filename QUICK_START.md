# Word Raid: Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies
```bash
cd /Users/dkumar/CascadeProjects/wordraid
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

That's it! The app will run with test ads and placeholder Play Games IDs.

## 🎮 Test the Game

1. **Home Screen**: You'll see banner ad at bottom (test ad)
2. **Tap "PLAY NOW"**: Starts a 60-second game
3. **Swipe Letters**: Connect adjacent letters to form words
4. **Submit Words**: Tap "SUBMIT WORD" button
5. **Game Over**: After 60 seconds, see interstitial ad
6. **Revive Option**: Watch rewarded ad for +20 seconds

## 📝 Before Publishing

### 1. Update Ad IDs (5 minutes)

**File**: `android/app/src/main/AndroidManifest.xml`
```xml
<!-- Replace this line -->
android:value="ca-app-pub-3940256099942544~3347511713"
<!-- With your AdMob App ID -->
android:value="ca-app-pub-YOUR_PUBLISHER_ID~YOUR_APP_ID"
```

**File**: `lib/ads/ad_service.dart`
```dart
// Replace these 3 lines with your ad unit IDs
static const String _androidBannerAdUnitId = 'YOUR_BANNER_ID';
static const String _androidInterstitialAdUnitId = 'YOUR_INTERSTITIAL_ID';
static const String _androidRewardedAdUnitId = 'YOUR_REWARDED_ID';
```

### 2. Update Play Games IDs (10 minutes)

**File**: `lib/services/play_games/play_games_service.dart`
```dart
// Replace these with IDs from Play Console
static const String achievement100Words = 'YOUR_ACHIEVEMENT_ID';
static const String achievement1000Score = 'YOUR_ACHIEVEMENT_ID';
static const String achievement7DayStreak = 'YOUR_ACHIEVEMENT_ID';
static const String achievementRaidComplete = 'YOUR_ACHIEVEMENT_ID';

static const String leaderboardDaily = 'YOUR_LEADERBOARD_ID';
static const String leaderboardAllTime = 'YOUR_LEADERBOARD_ID';
```

### 3. Create Signing Key (5 minutes)

```bash
keytool -genkey -v -keystore ~/wordraid-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias wordraid
```

Create `android/key.properties`:
```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=wordraid
storeFile=/Users/YOUR_USERNAME/wordraid-release-key.jks
```

### 4. Build Release (2 minutes)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 5. Upload to Play Store

1. Go to [Google Play Console](https://play.google.com/console/)
2. Create new app or select existing
3. Upload AAB file
4. Fill in store listing
5. Submit for review

## 🎯 Quick Testing Checklist

- [ ] App launches without errors
- [ ] Banner ad shows on home screen
- [ ] Game starts and timer counts down
- [ ] Can select and submit words
- [ ] Interstitial ad shows after game
- [ ] Revive button shows rewarded ad
- [ ] Score is saved (check "Best" score)
- [ ] Leaderboard button opens (may need Play Games setup)

## 🐛 Common Issues

### "Ads not loading"
- **Solution**: Test ads take 30-60 seconds to load. Be patient!
- Check internet connection
- Verify AdMob App ID is correct

### "Play Games not working"
- **Solution**: Play Games requires app to be published (even to internal testing)
- Add SHA-1 fingerprint to Play Console
- Sign in with test account

### "Build failed"
- **Solution**: Run `flutter clean && flutter pub get`
- Check Flutter version: `flutter doctor`
- Update dependencies: `flutter pub upgrade`

## 📱 Test on Real Device

```bash
# Connect Android device via USB
# Enable USB debugging on device
flutter devices  # Verify device is connected
flutter run --release  # Run release build
```

## 🎨 Customize

### Change Grid Size (4x4 → 5x5)
**File**: `lib/providers/game_provider.dart`
```dart
int _gridSize = 5;  // Change from 4
```

### Change Game Duration
**File**: `lib/models/game_state.dart`
```dart
timeRemaining: 90,  // Change from 60
```

### Change App Colors
**File**: `lib/main.dart`
```dart
seedColor: const Color(0xFFYOUR_COLOR),
```

## 📊 Monitor Performance

After publishing:
1. Check [AdMob Dashboard](https://apps.admob.google.com/) for ad revenue
2. Check [Play Console](https://play.google.com/console/) for:
   - Crash reports
   - ANRs (App Not Responding)
   - User reviews
   - Install metrics

## 🆘 Need Help?

- **Flutter Docs**: https://docs.flutter.dev/
- **AdMob Help**: https://support.google.com/admob/
- **Play Games**: https://developers.google.com/games/services

---

**Ready to launch? Let's go! 🚀**
