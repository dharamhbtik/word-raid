# 🎮 How to Get Your Google Play Games IDs

## Overview
Google Play Games Services requires you to set up your game in the Google Play Console first. Here's the complete step-by-step guide.

---

## 📋 Prerequisites

1. **Google Play Console Account** ($25 one-time fee)
   - Sign up at: https://play.google.com/console/signup
   
2. **App Created in Play Console**
   - You need to create your app first (can be in draft state)

---

## 🚀 Step-by-Step Guide

### Step 1: Access Play Console

1. Go to [Google Play Console](https://play.google.com/console/)
2. Sign in with your Google account
3. Select your app (or create new app if you haven't)

### Step 2: Set Up Play Games Services

1. In the left sidebar, scroll down to **"Grow"** section
2. Click **"Play Games Services"**
3. Click **"Setup and management"**
4. Click **"Configuration"**

### Step 3: Create Achievements

1. Click **"Achievements"** tab
2. Click **"Create achievement"** button
3. Fill in details for each achievement:

#### Achievement 1: 100 Total Words
- **Name**: "Word Master"
- **Description**: "Find 100 total words"
- **Icon**: Upload 512x512 image (trophy icon)
- **Points**: 10
- **Type**: Standard
- Click **"Save"**
- **Copy the Achievement ID** (format: `CgkI...`)

#### Achievement 2: 1000+ Score in One Round
- **Name**: "High Scorer"
- **Description**: "Score 1000+ points in a single round"
- **Icon**: Upload 512x512 image (star icon)
- **Points**: 25
- Click **"Save"**
- **Copy the Achievement ID**

#### Achievement 3: 7-Day Streak
- **Name**: "Dedicated Player"
- **Description**: "Play for 7 consecutive days"
- **Icon**: Upload 512x512 image (fire icon)
- **Points**: 50
- Click **"Save"**
- **Copy the Achievement ID**

#### Achievement 4: Raid Mode Complete
- **Name**: "Monster Slayer"
- **Description**: "Complete Raid Mode and recover all letters"
- **Icon**: Upload 512x512 image (shield icon)
- **Points**: 100
- Click **"Save"**
- **Copy the Achievement ID**

### Step 4: Create Leaderboards

1. Click **"Leaderboards"** tab
2. Click **"Create leaderboard"** button

#### Leaderboard 1: Daily High Scores
- **Name**: "Daily Champions"
- **Icon**: Upload 512x512 image (calendar icon)
- **Order**: Larger is better
- **Score format**: Numeric
- Click **"Save"**
- **Copy the Leaderboard ID** (format: `CgkI...`)

#### Leaderboard 2: All-Time High Scores
- **Name**: "All-Time Legends"
- **Icon**: Upload 512x512 image (trophy icon)
- **Order**: Larger is better
- **Score format**: Numeric
- Click **"Save"**
- **Copy the Leaderboard ID**

### Step 5: Link Your App

1. Go back to **"Configuration"** tab
2. Click **"Add credential"**
3. Select **"Android"**
4. Enter your package name: `com.zenithcodestudio.wordraid`
5. Get your SHA-1 fingerprint:

```bash
# For debug builds (testing)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release builds (production)
keytool -list -v -keystore ~/wordraid-release-key.jks -alias wordraid
```

6. Copy the **SHA-1** fingerprint (format: `AA:BB:CC:...`)
7. Paste it in Play Console
8. Click **"Save"**

### Step 6: Publish Configuration

1. Click **"Publish"** button (top right)
2. Wait for confirmation (usually instant)

---

## 📝 Where to Find Your IDs

### Achievement IDs
After creating each achievement, you'll see the ID in the achievement list:
- Format: `CgkIxxxxxxxxxxxxxxxxxxx`
- Example: `CgkI4P7Dz8MPEAIQAQ`

### Leaderboard IDs
After creating each leaderboard, you'll see the ID in the leaderboard list:
- Format: `CgkIxxxxxxxxxxxxxxxxxxx`
- Example: `CgkI4P7Dz8MPEAIQAg`

---

## 🔧 Update Your App Code

Once you have all IDs, update this file:

**File**: `lib/services/play_games/play_games_service.dart`

```dart
// Replace these lines (around line 11-18)

// Achievement IDs - FROM PLAY CONSOLE
static const String achievement100Words = 'CgkI4P7Dz8MPEAIQAQ'; // Your actual ID
static const String achievement1000Score = 'CgkI4P7Dz8MPEAIQAw'; // Your actual ID
static const String achievement7DayStreak = 'CgkI4P7Dz8MPEAIQBA'; // Your actual ID
static const String achievementRaidComplete = 'CgkI4P7Dz8MPEAIQBQ'; // Your actual ID

// Leaderboard IDs - FROM PLAY CONSOLE
static const String leaderboardDaily = 'CgkI4P7Dz8MPEAIQAg'; // Your actual ID
static const String leaderboardAllTime = 'CgkI4P7Dz8MPEAIQBg'; // Your actual ID
```

---

## 🧪 Testing Play Games

### Before Publishing

1. **Add Test Accounts**:
   - In Play Console → Play Games Services → Setup → Testers
   - Add your email and test accounts
   
2. **Publish to Internal Testing**:
   - You must publish your app (even to internal testing) for Play Games to work
   - Go to Play Console → Testing → Internal testing
   - Create release and upload your AAB
   
3. **Test Sign-In**:
   - Install app from internal testing
   - Tap achievements/leaderboard buttons
   - Should see Play Games sign-in prompt

### Common Issues

**Issue**: "Sign-in failed"
- **Solution**: Make sure SHA-1 is added correctly
- **Solution**: App must be published to at least internal testing
- **Solution**: Use whitelisted test account

**Issue**: "Achievement not unlocking"
- **Solution**: Verify achievement ID is correct
- **Solution**: Check Play Games configuration is published
- **Solution**: Wait a few minutes (can take time to sync)

---

## 📸 Visual Guide

### Finding Achievement IDs:
```
Play Console → Your App → Grow → Play Games Services → 
Setup and management → Configuration → Achievements → 
Click on achievement → See ID in details
```

### Finding Leaderboard IDs:
```
Play Console → Your App → Grow → Play Games Services → 
Setup and management → Configuration → Leaderboards → 
Click on leaderboard → See ID in details
```

---

## 🎯 Quick Checklist

- [ ] Google Play Console account created
- [ ] App created in Play Console
- [ ] Play Games Services enabled
- [ ] 4 Achievements created
- [ ] 2 Leaderboards created
- [ ] Achievement IDs copied
- [ ] Leaderboard IDs copied
- [ ] SHA-1 fingerprint added
- [ ] Configuration published
- [ ] IDs updated in code
- [ ] App published to internal testing (minimum)
- [ ] Tested with test account

---

## 💡 Pro Tips

1. **Create achievements early** - They can't be deleted, only hidden
2. **Use descriptive names** - Players will see these
3. **Design nice icons** - 512x512 PNG, simple and clear
4. **Test thoroughly** - Use internal testing track
5. **Add multiple SHA-1s** - Debug and release keys
6. **Whitelist testers** - Add test accounts before testing

---

## 🆘 Still Need Help?

### Official Documentation
- [Play Games Services Setup](https://developers.google.com/games/services/console/enabling)
- [Achievements Guide](https://developers.google.com/games/services/common/concepts/achievements)
- [Leaderboards Guide](https://developers.google.com/games/services/common/concepts/leaderboards)

### Video Tutorials
- Search YouTube: "Google Play Games Services setup"
- Search YouTube: "Android achievements and leaderboards"

---

## 📋 Example IDs (DO NOT USE - These are examples)

```dart
// ❌ EXAMPLE ONLY - Replace with your actual IDs
static const String achievement100Words = 'CgkI4P7Dz8MPEAIQAQ';
static const String achievement1000Score = 'CgkI4P7Dz8MPEAIQAw';
static const String achievement7DayStreak = 'CgkI4P7Dz8MPEAIQBA';
static const String achievementRaidComplete = 'CgkI4P7Dz8MPEAIQBQ';
static const String leaderboardDaily = 'CgkI4P7Dz8MPEAIQAg';
static const String leaderboardAllTime = 'CgkI4P7Dz8MPEAIQBg';
```

---

**Total Time**: 30-45 minutes  
**Difficulty**: Medium  
**Cost**: Free (part of Play Console account)

**Good luck setting up Play Games! 🎮**
