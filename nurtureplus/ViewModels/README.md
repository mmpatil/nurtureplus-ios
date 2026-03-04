# Nurture+ 👶💝

**Nurture+** is a comprehensive baby tracking and postpartum recovery app designed to support new parents through their journey. Track your baby's daily activities while monitoring your own recovery and well-being.

---

## 📱 Features

### 🍼 Baby Tracking

#### Multiple Baby Profiles
- Create and manage profiles for multiple babies
- Each profile includes:
  - Baby's name and photo
  - Birth date with automatic age calculation
  - Age displayed in days, weeks, or months (automatically adjusts)
  - Quick profile switching from the home screen

#### Feeding Tracking
- **Feeding Types**:
  - Breastfeeding (left, right, or both sides)
  - Bottle feeding
  - Pumping
- **Details Captured**:
  - Timestamp
  - Duration (for breastfeeding)
  - Amount in ounces (for bottles)
  - Side(s) used (for breastfeeding)
  - Optional notes
- **Smart Features**:
  - Quick-add from home screen
  - Edit or delete past entries
  - View feeding history
  - Track feeding patterns

#### Diaper Changes
- **Diaper Types**:
  - Wet only
  - Dirty only
  - Both wet and dirty
- **Information Tracked**:
  - Timestamp
  - Type of change
  - Optional notes
- **Quick Actions**:
  - One-tap logging from home screen
  - History view
  - Edit or delete entries

#### Sleep Tracking
- **Sleep Data**:
  - Start and end times
  - Automatic duration calculation
  - Sleep quality notes
- **Features**:
  - Track naps and nighttime sleep
  - View total daily sleep hours
  - Edit ongoing or past sleep sessions
  - See sleep patterns over time

### 💝 Mom Recovery Check-In

A dedicated feature to track postpartum recovery and maternal well-being with fewer clicks and better insights.

#### Mood Tracking
Track your emotional state with 5 mood levels:
- 😊 **Great** - Feeling wonderful
- 🙂 **Good** - Doing well
- 😐 **Okay** - Getting by
- 😔 **Struggling** - Having a hard time
- 😰 **Overwhelmed** - Need support

#### Energy Levels
Monitor your energy throughout the day:
- 🔋 **Very Low** - Exhausted
- 🪫 **Low** - Tired
- ⚡️ **Moderate** - Managing
- ✨ **High** - Energized
- 🌟 **Very High** - Thriving

#### Water Intake Tracking
- Track daily water consumption in ounces
- Visual slider for easy input (0-128 oz)
- Quick increment buttons (+8 oz, +16 oz, Reset)
- Helpful reminder: 64-100 oz recommended while breastfeeding
- See your hydration progress at a glance

#### Symptom Logging
Track up to 10 postpartum symptoms:
- 🩹 **Soreness** - General body soreness
- 💧 **Bleeding** - Postpartum bleeding
- 💓 **Cramping** - Uterine cramping
- ❤️ **Breast Pain** - Breastfeeding discomfort
- 🧠 **Headache** - Head pain or tension
- 🤢 **Nausea** - Upset stomach
- ⚠️ **Anxiety** - Feeling anxious or worried
- 🌧️ **Sadness** - Feeling down or tearful
- 😴 **Insomnia** - Trouble sleeping
- 🔥 **Hot Flashes** - Temperature fluctuations

#### Recovery History
- View all past recovery check-ins
- See trends over time
- Track improvements in mood and energy
- Monitor symptom patterns
- Easy access from home screen

### 📊 Analytics & Insights

#### Today's Summary
Real-time dashboard showing:
- Total feedings today
- Total diaper changes today
- Total hours of sleep today
- Quick stats at a glance

#### Analytics View
- Detailed trends and patterns
- Visual charts and graphs
- Historical data analysis
- Identify patterns in baby's routine

#### Recent Activity Feed
- Chronological view of all activities
- See the last 3 entries of each type
- Quick overview of the day
- Relative timestamps ("2 hours ago")

### 🎨 User Interface

#### Design Features
- **Clean, Modern Interface**: Nurture+ design system with consistent spacing, colors, and typography
- **Card-Based Layout**: Easy-to-read information cards
- **Color-Coded Categories**:
  - 💙 Blue for feeding
  - 💚 Green for diapers
  - 💜 Purple for sleep
  - ❤️ Pink/Red for recovery
- **Intuitive Icons**: SF Symbols for familiar, native experience
- **Smooth Animations**: Delightful interactions throughout

#### Navigation
- **Tab-Based Navigation**:
  - Home: Dashboard with quick actions
  - Tracking: Detailed activity logging
  - Profile: Baby profiles and settings
- **Pull-to-Refresh**: Update data anytime
- **Modal Sheets**: Non-intrusive data entry

#### Quick Actions
- Prominent quick-action buttons on home screen
- Floating action button in tracking view
- One-tap access to most common tasks
- Reduced friction for busy parents

### 🔄 Data Management

#### Persistence
- All data stored locally using `DataManager`
- JSON-based file storage
- Automatic save/load operations
- Data persists between app launches

#### Features
- **Create**: Add new entries easily
- **Read**: View all past entries
- **Update**: Edit entries anytime
- **Delete**: Remove entries with confirmation
- **Multiple Babies**: Separate data for each baby profile

---

## 🏗️ Technical Architecture

### SwiftUI-Based
- Modern declarative UI framework
- Reactive data updates
- Native iOS/iPadOS experience

### MVVM Pattern
- **Models**: `BabyProfile`, `FeedingEntry`, `DiaperEntry`, `SleepEntry`, `RecoveryEntry`, `MoodEntry`
- **ViewModels**: `HomeViewModel`, `TrackingViewModel`, `RecoveryViewModel`, `ProfileViewModel`, `AnalyticsViewModel`
- **Views**: Modular, reusable SwiftUI views
- **DataManager**: Centralized data persistence layer

### Key Components

#### Models
- `BabyProfile`: Baby information and age calculations
- `FeedingEntry`: Feeding sessions with type, duration, and amount
- `DiaperEntry`: Diaper changes with type classification
- `SleepEntry`: Sleep sessions with start/end times
- `RecoveryEntry`: Mom's recovery check-ins with mood, energy, water, symptoms
- `MoodType`: 5 mood states with emoji and color coding
- `RecoveryEnergyLevel`: 5 energy levels
- `Symptom`: 10 postpartum symptoms

#### View Models
- Handle business logic
- Manage state
- Coordinate data operations
- Provide computed properties for views

#### Design System
- `NurtureColors`: Consistent color palette
- `NurtureSpacing`: Standard spacing values
- `NurtureCornerRadius`: Rounded corner standards
- `NurtureCard`: Reusable card component

---

## 🚀 Key User Flows

### Adding a Baby Profile
1. Navigate to Profile tab
2. Tap "Add Baby Profile"
3. Enter name and birth date
4. Optionally add photo
5. Save to create profile

### Quick-Log a Feeding
1. From home screen, tap "Feeding" quick action
2. Select feeding type
3. Enter details (duration/amount)
4. Tap "Save"
5. Return to home screen with updated stats

### Mom Recovery Check-In
1. Tap "How are you feeling?" card on home screen
2. Select your current mood (5 options)
3. Choose energy level (5 options)
4. Adjust water intake slider
5. Select any symptoms you're experiencing
6. Add optional notes
7. Save entry
8. View history anytime with one tap

### View Analytics
1. Tap "View Analytics" on home screen
2. Explore trends and patterns
3. See historical data visualizations

---

## 💡 Design Philosophy

### For Parents, By Parents
Nurture+ is designed with the realities of new parenthood in mind:
- **Quick Input**: Most tasks take seconds
- **One-Handed Operation**: Large tap targets
- **Fewer Clicks**: Streamlined workflows
- **Offline-First**: No internet required
- **Privacy-Focused**: All data stored locally

### Balanced Tracking
Track enough to understand patterns without creating burden:
- Essential data points only
- Optional notes for details
- Visual summaries over raw numbers
- Encourage self-care alongside baby care

### Mom-Centric Recovery
Unique focus on maternal well-being:
- Dedicated recovery tracking
- Personal, empathetic language ("How are you feeling?")
- Holistic view: mood + energy + physical symptoms
- Easy access to historical trends
- Gentle reminders for hydration

---

## 🎯 Target Users

- New parents (especially moms)
- Parents of newborns and infants
- Parents managing multiple babies
- Anyone tracking baby patterns for pediatrician visits
- Moms monitoring postpartum recovery

---

## 📝 Future Enhancements

Potential features for future versions:
- [ ] Growth tracking (weight, height, head circumference)
- [ ] Milestone tracking
- [ ] Photo timeline
- [ ] Export data for pediatrician
- [ ] Reminder notifications
- [ ] Partner/caregiver sharing
- [ ] Pumping schedule optimization
- [ ] Weekly/monthly summary reports
- [ ] Dark mode
- [ ] iPad optimization
- [ ] Apple Watch companion app
- [ ] Widgets for quick logging
- [ ] iCloud sync across devices

---

## 🔒 Privacy & Security

- **100% Local Storage**: All data stays on your device
- **No Account Required**: Start tracking immediately
- **No Analytics**: Your data is yours alone
- **No Cloud Sync**: Complete privacy (offline-only)
- **Secure by Default**: Native iOS security model

---

## 📄 License

© 2026 Nurture+. All rights reserved.

---

## 👥 Credits

**Created by**: Manali Maruti Pat  
**Date**: March 3, 2026  
**Platform**: iOS/iPadOS  
**Framework**: SwiftUI  

---

## 🙏 Acknowledgments

Built with love for all the amazing parents out there. You're doing great! 💝

---

**Nurture+ - Caring for baby, caring for you.**
