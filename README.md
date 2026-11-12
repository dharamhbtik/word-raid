# Word Raid: Daily Rescue

A fast, addictive word puzzle game for Android with Google Mobile Ads integration and Google Play Games Services.

## 📱 Features

### Core Gameplay
- **4x4 or 5x5 letter grid** with random letter generation
- **Swipe mechanics** to form words by connecting adjacent letters
- **60-second rounds** with real-time countdown
- **Offline dictionary validation** for word checking
- **Dynamic scoring system** with length multipliers and streak bonuses
- **Smooth animations** for letter selection and word formation

### Game Modes
- **Classic Mode**: Standard 60-second word hunt
- **Daily Challenges**: New challenges every 24 hours with specific targets
- **Raid Mode**: Unique mechanic where a Word Monster steals letters every 24 hours - play to recover them!

### Monetization (Google Mobile Ads)
- **Banner Ads** on home screen
- **Interstitial Ads** after each game round
- **Rewarded Ads** for:
  - Revive with +20 seconds
  - Extra hints
  - Bonus daily rewards

### Google Play Games Integration
- **Sign-in** with Google Play Games
- **Leaderboards** (Daily & All-Time)
- **Achievements**:
  - Find 100 total words
  - Score 1000+ in one round
  - Maintain 7-day streak
  - Complete Raid Mode
- **Cloud Save** for progress sync
- **XP and Level Up** system

### UI/UX
- **Modern, premium design** with gradient backgrounds
- **Dark mode** support
- **Smooth animations** using flutter_animate
- **Haptic feedback** and sound effects
- **Daily login rewards**
- **Game over screen** with stats and revive option

## 🏗️ Architecture

The project follows **Clean Architecture** with **Riverpod** state management:

```
lib/
├── core/                    # Core utilities and constants
├── features/
│   ├── game/               # Main game logic
│   └── raid_mode/          # Raid mode specific features
├── ads/                    # Google Mobile Ads service
├── services/
│   ├── dictionary/         # Word validation service
│   └── play_games/         # Google Play Games service
├── ui/
│   ├── screens/            # App screens
│   └── widgets/            # Reusable widgets
├── models/                 # Data models
├── providers/              # Riverpod providers
└── main.dart              # App entry point
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio or VS Code
- Android SDK with minimum API level 24
- Google AdMob account
- Google Play Console account (for Play Games)

### 1. Clone and Install Dependencies

```bash
cd /Users/dkumar/CascadeProjects/wordraid
flutter pub get
```

### 2. Configure Google Mobile Ads

#### Get Your AdMob App ID and Ad Unit IDs:
1. Go to [Google AdMob Console](https://apps.admob.google.com/)
2. Create a new app or select existing app
3. Get your **App ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY`)
4. Create ad units for:
   - Banner Ad
   - Interstitial Ad
   - Rewarded Ad
5. Get the **Ad Unit IDs** for each

#### Update AndroidManifest.xml:
Replace the test App ID in `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
```

#### Update Ad Service:
Replace test ad unit IDs in `lib/ads/ad_service.dart`:

```dart
// Replace these with your actual Ad Unit IDs
static const String _androidBannerAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
static const String _androidInterstitialAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
static const String _androidRewardedAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
```

### 3. Configure Google Play Games Services

#### Set up in Google Play Console:
1. Go to [Google Play Console](https://play.google.com/console/)
2. Select your app (or create new app)
3. Navigate to **Play Games Services** → **Setup and management** → **Configuration**
4. Create **Achievements**:
   - 100 Total Words
   - 1000 Score in One Round
   - 7-Day Streak
   - Raid Mode Complete
5. Create **Leaderboards**:
   - Daily Leaderboard
   - All-Time Leaderboard
6. Get the **Achievement IDs** and **Leaderboard IDs**

#### Update Play Games Service:
Replace placeholder IDs in `lib/services/play_games/play_games_service.dart`:

```dart
// Achievement IDs
static const String achievement100Words = 'CgkI...YOUR_ID_HERE';
static const String achievement1000Score = 'CgkI...YOUR_ID_HERE';
static const String achievement7DayStreak = 'CgkI...YOUR_ID_HERE';
static const String achievementRaidComplete = 'CgkI...YOUR_ID_HERE';

// Leaderboard IDs
static const String leaderboardDaily = 'CgkI...YOUR_ID_HERE';
static const String leaderboardAllTime = 'CgkI...YOUR_ID_HERE';
```

### 4. Configure Firebase (Optional but Recommended)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Add Android app with package name: `com.zenithcodestudio.wordraid`
4. Download `google-services.json`
5. Place it in `android/app/`
6. Update `android/build.gradle.kts` to include Firebase plugin

### 5. Build and Test

#### Debug Build:
```bash
flutter run
```

#### Release Build (APK):
```bash
flutter build apk --release
```

#### Release Build (App Bundle for Play Store):
```bash
flutter build appbundle --release
```

The output will be in:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### 6. Create Signing Key (for Production)

```bash
keytool -genkey -v -keystore ~/wordraid-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias wordraid
```

Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=wordraid
storeFile=/path/to/wordraid-release-key.jks
```

Update `android/app/build.gradle.kts` to use signing config.

## 📦 Publishing to Google Play Store

### 1. Prepare Assets
- App icon (512x512 PNG)
- Feature graphic (1024x500)
- Screenshots (at least 2)
- Privacy policy URL

### 2. Create Store Listing
1. Go to Google Play Console
2. Fill in:
   - App name: **Word Raid: Daily Rescue**
   - Short description
   - Full description
   - Category: **Word Games**
   - Content rating
   - Privacy policy

### 3. Upload App Bundle
1. Create a new release in **Production** or **Internal Testing**
2. Upload the AAB file
3. Fill in release notes
4. Submit for review

### 4. Data Safety Section
Declare:
- **Ads**: App displays ads
- **Analytics**: If using Firebase Analytics
- **No personal data collection** (unless you add features that do)

## 🎮 How to Play

1. **Start Game**: Tap "PLAY NOW" on home screen
2. **Form Words**: Swipe across adjacent letters to form words
3. **Submit**: Tap "SUBMIT WORD" or release swipe
4. **Score Points**: Longer words = more points, build streaks for bonuses
5. **Beat the Clock**: You have 60 seconds per round
6. **Revive**: Watch a rewarded ad to get +20 seconds

## 🛠️ Customization

### Change Grid Size
In `lib/providers/game_provider.dart`:
```dart
int _gridSize = 5; // Change from 4 to 5 for 5x5 grid
```

### Adjust Game Duration
In `lib/models/game_state.dart`:
```dart
timeRemaining: 90, // Change from 60 to 90 seconds
```

### Add More Words to Dictionary
Edit `assets/dictionary/words.txt` and add one word per line.

## 📊 Performance Optimization

- **Target 60+ FPS** on most devices
- **Lazy loading** for ads
- **Efficient word validation** using HashSet
- **Minimal rebuilds** with Riverpod
- **Optimized animations** with flutter_animate

## 🐛 Troubleshooting

### Ads not showing:
- Check AdMob App ID is correct
- Verify ad unit IDs are correct
- Test ads may take time to load
- Check internet connection

### Play Games not working:
- Verify app is published (at least to internal testing)
- Check achievement/leaderboard IDs
- Ensure SHA-1 fingerprint is added in Play Console

### Build errors:
```bash
flutter clean
flutter pub get
flutter build apk
```

## 📝 License

This project is created for educational and commercial purposes.

## 🤝 Support

For issues or questions:
- Email: support@zenithcodestudio.com
- Package ID: com.zenithcodestudio.wordraid

---

**Built with ❤️ using Flutter**
