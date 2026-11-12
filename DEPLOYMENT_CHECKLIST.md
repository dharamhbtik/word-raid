# 🚀 Word Raid: Deployment Checklist

## ✅ Pre-Deployment Checklist

### 1. Code Quality
- [x] All core features implemented
- [x] Game logic working correctly
- [x] Ads integration complete
- [x] Play Games integration complete
- [x] State management with Riverpod
- [x] Dictionary loaded (370,000+ words)
- [ ] Run `flutter analyze` and fix critical issues
- [ ] Run `flutter test` and ensure tests pass
- [ ] Test on multiple devices

### 2. Replace Test IDs

#### AdMob Configuration
- [ ] **Get AdMob App ID** from [AdMob Console](https://apps.admob.google.com/)
- [ ] **Update AndroidManifest.xml** (line 12-14)
  ```xml
  android:value="ca-app-pub-YOUR_PUBLISHER_ID~YOUR_APP_ID"
  ```
- [ ] **Get Banner Ad Unit ID**
- [ ] **Get Interstitial Ad Unit ID**
- [ ] **Get Rewarded Ad Unit ID**
- [ ] **Update lib/ads/ad_service.dart** (lines 14-16)
  ```dart
  static const String _androidBannerAdUnitId = 'YOUR_BANNER_ID';
  static const String _androidInterstitialAdUnitId = 'YOUR_INTERSTITIAL_ID';
  static const String _androidRewardedAdUnitId = 'YOUR_REWARDED_ID';
  ```

#### Google Play Games Configuration
- [ ] **Create app** in [Play Console](https://play.google.com/console/)
- [ ] **Set up Play Games Services**
- [ ] **Create 4 Achievements**:
  - [ ] 100 Total Words Found
  - [ ] 1000+ Score in One Round
  - [ ] 7-Day Login Streak
  - [ ] Raid Mode Complete
- [ ] **Create 2 Leaderboards**:
  - [ ] Daily High Scores
  - [ ] All-Time High Scores
- [ ] **Copy Achievement IDs**
- [ ] **Copy Leaderboard IDs**
- [ ] **Update lib/services/play_games/play_games_service.dart** (lines 11-18)
  ```dart
  static const String achievement100Words = 'YOUR_ACHIEVEMENT_ID';
  static const String achievement1000Score = 'YOUR_ACHIEVEMENT_ID';
  static const String achievement7DayStreak = 'YOUR_ACHIEVEMENT_ID';
  static const String achievementRaidComplete = 'YOUR_ACHIEVEMENT_ID';
  static const String leaderboardDaily = 'YOUR_LEADERBOARD_ID';
  static const String leaderboardAllTime = 'YOUR_LEADERBOARD_ID';
  ```

### 3. App Signing

- [ ] **Generate signing key**:
  ```bash
  keytool -genkey -v -keystore ~/wordraid-release-key.jks \
    -keyalg RSA -keysize 2048 -validity 10000 -alias wordraid
  ```
- [ ] **Create android/key.properties**:
  ```properties
  storePassword=YOUR_STORE_PASSWORD
  keyPassword=YOUR_KEY_PASSWORD
  keyAlias=wordraid
  storeFile=/Users/YOUR_USERNAME/wordraid-release-key.jks
  ```
- [ ] **Update android/app/build.gradle.kts** to use signing config
- [ ] **Backup signing key** to secure location
- [ ] **Document passwords** in secure password manager

### 4. Privacy & Legal

- [ ] **Create Privacy Policy** (HTML page)
  - [ ] Describe data collection (ads, analytics)
  - [ ] List third-party services (AdMob, Play Games)
  - [ ] Explain user rights
  - [ ] Add contact information
- [ ] **Host Privacy Policy** (GitHub Pages, Firebase, or own domain)
- [ ] **Get Privacy Policy URL**
- [ ] **Create Terms of Service** (optional but recommended)

### 5. Store Assets

#### Required Graphics
- [ ] **App Icon** (512x512 PNG)
- [ ] **Feature Graphic** (1024x500 PNG)
- [ ] **Screenshots** (minimum 2, recommended 4-8)
  - [ ] Home screen
  - [ ] Gameplay
  - [ ] Game over screen
  - [ ] Achievements/Leaderboard

#### Optional Graphics
- [ ] **Promo Video** (30 seconds, YouTube)
- [ ] **TV Banner** (1280x720)
- [ ] **Wear OS Screenshots**

### 6. Store Listing

- [ ] **App Name**: "Word Raid: Daily Rescue"
- [ ] **Short Description** (80 characters max):
  ```
  Fast word puzzle game! Swipe letters, form words, beat the clock. Daily fun!
  ```
- [ ] **Full Description** (4000 characters max):
  ```
  🎮 WORD RAID: DAILY RESCUE 🎮
  
  The most addictive word puzzle game is here! Swipe across letters to form words 
  and rescue them from the Word Monster. Can you beat the 60-second challenge?
  
  ⚡ FEATURES:
  • Fast-paced 60-second rounds
  • Swipe to connect adjacent letters
  • 370,000+ word dictionary
  • Daily challenges with special rewards
  • Unique Raid Mode - recover stolen letters!
  • Google Play Games achievements
  • Global leaderboards
  • Beautiful dark mode
  • Smooth animations and haptic feedback
  
  🎯 HOW TO PLAY:
  1. Swipe across adjacent letters to form words
  2. Submit valid words to score points
  3. Longer words = more points!
  4. Build streaks for bonus multipliers
  5. Beat the 60-second timer
  
  🏆 COMPETE & ACHIEVE:
  • Climb the global leaderboards
  • Unlock achievements
  • Track your progress
  • Challenge friends
  
  🎁 DAILY REWARDS:
  • New challenges every 24 hours
  • Login rewards
  • Raid Mode events
  
  Perfect for word game lovers, puzzle enthusiasts, and anyone who wants a quick 
  brain workout! Download now and start your word adventure!
  
  Free to play with optional ads for extra lives and hints.
  ```
- [ ] **Category**: Word
- [ ] **Tags**: word game, puzzle, brain training, vocabulary
- [ ] **Content Rating**: Complete questionnaire (E for Everyone)
- [ ] **Privacy Policy URL**: Add your URL
- [ ] **Contact Email**: support@zenithcodestudio.com (or your email)

### 7. Data Safety Declaration

- [ ] **Data Collection**: Declare what data is collected
  - [ ] ✅ Advertising data (via AdMob)
  - [ ] ✅ Gaming data (via Play Games)
  - [ ] ❌ No personal information
- [ ] **Data Usage**: Explain how data is used
  - [ ] Advertising
  - [ ] Analytics
  - [ ] Game functionality
- [ ] **Data Sharing**: List third parties
  - [ ] Google AdMob
  - [ ] Google Play Games Services
- [ ] **Security**: Describe data protection measures

### 8. Testing

#### Functional Testing
- [ ] **Install fresh** on test device
- [ ] **Test game flow**: Home → Play → Game Over → Home
- [ ] **Test ads**:
  - [ ] Banner ad loads on home screen
  - [ ] Interstitial ad shows after game
  - [ ] Rewarded ad works for revive
- [ ] **Test Play Games**:
  - [ ] Sign in works
  - [ ] Achievements unlock
  - [ ] Leaderboard submission works
  - [ ] Leaderboard display works
- [ ] **Test persistence**:
  - [ ] Best score saves
  - [ ] Stats persist across sessions
- [ ] **Test edge cases**:
  - [ ] No internet connection
  - [ ] Airplane mode
  - [ ] Low memory
  - [ ] App backgrounding

#### Device Testing
- [ ] **Test on Android 7.0** (minSdk 24)
- [ ] **Test on Android 14/15** (latest)
- [ ] **Test on small screen** (5" phone)
- [ ] **Test on large screen** (6.5"+ phone)
- [ ] **Test on tablet** (optional)
- [ ] **Test dark mode**
- [ ] **Test light mode**

#### Performance Testing
- [ ] **Check FPS** (should be 60+)
- [ ] **Check memory usage** (should be <150MB)
- [ ] **Check battery drain** (should be minimal)
- [ ] **Check app size** (should be <50MB)

### 9. Build Release

- [ ] **Clean build**:
  ```bash
  flutter clean
  flutter pub get
  ```
- [ ] **Build App Bundle**:
  ```bash
  flutter build appbundle --release
  ```
- [ ] **Verify output**: `build/app/outputs/bundle/release/app-release.aab`
- [ ] **Check file size** (should be 20-40MB)
- [ ] **Test release build** on device:
  ```bash
  flutter install --release
  ```

### 10. Pre-Upload Verification

- [ ] **App Bundle** ready
- [ ] **Signing key** configured
- [ ] **All test IDs** replaced with production IDs
- [ ] **Privacy policy** live and accessible
- [ ] **Screenshots** prepared
- [ ] **Store listing** written
- [ ] **Content rating** completed
- [ ] **Data safety** declared

---

## 🚀 Upload to Play Store

### 1. Create Release

- [ ] Go to [Play Console](https://play.google.com/console/)
- [ ] Select your app
- [ ] Navigate to **Production** → **Create new release**
- [ ] Upload `app-release.aab`
- [ ] Add **Release name**: "1.0.0 - Initial Release"
- [ ] Add **Release notes**:
  ```
  🎉 Welcome to Word Raid: Daily Rescue!
  
  • Fast-paced word puzzle gameplay
  • 60-second rounds
  • Daily challenges
  • Raid Mode
  • Achievements and leaderboards
  • Beautiful dark mode
  
  Have fun and happy word hunting! 🎮
  ```

### 2. Review & Submit

- [ ] Review all information
- [ ] Check pricing (Free)
- [ ] Check countries (All or select)
- [ ] Submit for review

### 3. Wait for Review

- [ ] **Typical review time**: 1-7 days
- [ ] **Check status** daily
- [ ] **Respond to feedback** if rejected

---

## 📊 Post-Launch Checklist

### Week 1
- [ ] Monitor crash reports daily
- [ ] Check ad revenue in AdMob
- [ ] Respond to user reviews
- [ ] Track install numbers
- [ ] Monitor Play Games stats

### Week 2-4
- [ ] Analyze user behavior
- [ ] Plan feature updates
- [ ] A/B test ad placements
- [ ] Optimize for retention
- [ ] Prepare version 1.1

### Ongoing
- [ ] Weekly crash report review
- [ ] Monthly revenue analysis
- [ ] Quarterly feature updates
- [ ] Respond to all reviews
- [ ] Monitor competitors

---

## 🐛 Common Issues & Solutions

### Issue: Ads not showing
**Solution**: 
- Verify AdMob App ID is correct
- Check ad unit IDs
- Wait 24-48 hours for ads to activate
- Test with real device (not emulator)

### Issue: Play Games not working
**Solution**:
- Ensure app is published (internal testing OK)
- Add SHA-1 fingerprint to Play Console
- Use correct achievement/leaderboard IDs
- Test with whitelisted account

### Issue: App rejected
**Common reasons**:
- Privacy policy missing/incorrect
- Data safety declaration incomplete
- Content rating wrong
- Broken functionality
- Copyright issues

**Solution**: Read rejection email carefully and fix issues

### Issue: Low installs
**Solutions**:
- Improve store listing (better screenshots, description)
- Add keywords for ASO
- Share on social media
- Run ads campaign
- Get featured in collections

---

## 📈 Success Metrics

### Target Metrics (Month 1)
- **Installs**: 1,000+
- **DAU**: 100+
- **Retention D1**: 40%+
- **Retention D7**: 20%+
- **Ad Revenue**: $50+
- **Rating**: 4.0+

### Growth Strategy
1. **Organic**: ASO optimization, reviews
2. **Paid**: Google Ads, Facebook Ads
3. **Social**: Share on Reddit, Twitter, gaming forums
4. **PR**: Contact gaming blogs, YouTubers
5. **Updates**: Regular feature releases

---

## ✅ Final Pre-Launch Checklist

**Before clicking "Submit for Review":**

- [ ] All test IDs replaced ✓
- [ ] Privacy policy live ✓
- [ ] Store listing complete ✓
- [ ] Screenshots uploaded ✓
- [ ] App tested thoroughly ✓
- [ ] Signing key backed up ✓
- [ ] Release notes written ✓
- [ ] Content rating done ✓
- [ ] Data safety declared ✓
- [ ] App Bundle uploaded ✓

**If all checked, you're ready to launch! 🚀**

---

**Estimated Time**: 4-6 hours (mostly graphics and testing)  
**Launch Date**: Within 7 days of submission  
**Good luck! 🎉**
