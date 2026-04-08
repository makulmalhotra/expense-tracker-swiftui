<img width="412" height="770" alt="auth" src="https://github.com/user-attachments/assets/6e618de2-0da0-4e46-8c04-1437b9d69239" /># PayU — Personal Finance Manager

A polished iOS finance tracking app built with SwiftUI. Track income and expenses across multiple currencies, visualize spending habits with interactive charts, and manage your financial health — all with smooth animations and full light/dark mode support.

---

## Screenshots

| Home | Add Transaction | Balances |
|------|----------------|----------|
|<img width="392" height="752" alt="home" src="https://github.com/user-attachments/assets/47180084-02d9-46cd-9c01-f5cde06efd41" />|<img width="409" height="751" alt="add_transaction" src="https://github.com/user-attachments/assets/a312c559-43e2-4185-8957-39407c22c5ed" />|<img width="397" height="763" alt="balances" src="https://github.com/user-attachments/assets/3c324732-07b2-496b-a7ea-49516d0db9de" />|

| Financial Health | Profile | Auth |
|-----------------|---------|------|
|<img width="444" height="761" alt="financial_health" src="https://github.com/user-attachments/assets/e3081be9-066c-47e9-b497-e941f2a10c8a" />|<img width="455" height="758" alt="profile" src="https://github.com/user-attachments/assets/1214d1d8-ea66-48f0-9d60-ac19400ef05a" />|<img width="412" height="770" alt="auth" src="https://github.com/user-attachments/assets/a5f1bebb-cae3-4c67-bf53-6305039ee884" />|


---

## Features

### Transactions
- Add income and expense transactions with amount, category, date, and note
- Swipe to delete any transaction
- Star/favourite individual transactions
- View all transactions grouped by **week** or **month** — not just the current period
- Animated slide transition when switching between weekly and monthly views

### Multi-Currency Support
- 5 built-in currencies: CAD, USD, EUR, GBP, AUD
- Enable/disable currencies from the Balances tab
- Only enabled currencies appear in the Add Transaction sheet
- Favourite currencies for quick access

### Financial Health Gauge
- Animated horseshoe arc gauge (300–850 score range)
- Gradient arc: red → orange → yellow → green → teal
- Animated dot indicator with pulsing glow
- Score calculated from savings rate: `300 + (income − expenses) / income × 550`

### Charts & Analytics
- **Bar chart**: income vs expenses for the last 6 months, tap a bar for details
- **Pie chart**: spending breakdown by month
- **Donut chart**: spending by category with animated stagger on appear
- Toggle between bar and pie view with a smooth transition

### Home Screen
- Greeting changes based on time of day
- Credit card widget that **flips on tap** to reveal this month's income, expenses, and net balance
- Card entrance animation on first load

### Profile
- Edit name, email, and password
- Total spending, income, and net balance summary
- Dark/light mode toggle — persists across sessions

### Light & Dark Mode
- Full adaptive UI using `UIColor(dynamicProvider:)` — no `@Environment(\.colorScheme)` hacks
- Toggle in the Profile tab; preference saved to UserDefaults
- Every screen designed for both modes

### Auth
- Sign up and sign in with email + password
- Client-side validation (email format, password length, confirm match)
- All credentials stored locally via UserDefaults

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI |
| State Management | `@Observable` (Swift 5.9 Observation framework) |
| Architecture | MVVM |
| Persistence | UserDefaults (JSON encoded) |
| Charts | Swift Charts (`BarMark`, `SectorMark`) |
| Custom Drawing | SwiftUI `Canvas` + `Path` |
| Animations | SwiftUI spring animations, `contentTransition(.numericText())` |
| Theming | `UIColor(dynamicProvider:)` for adaptive colors |

---

## Project Structure

```
tuf_mm/
├── App/
│   ├── tuf_mmApp.swift              # Entry point, injects repository + color scheme
│   └── ContentView.swift            # Auth routing (sign in ↔ main app)
│
├── Models/
│   └── Models.swift                 # User, Transaction, Currency, enums
│
├── Core/
│   ├── AppTheme.swift               # Colors, layout constants, view modifiers, extensions
│   └── LocalRepository.swift        # Single source of truth — all data + persistence
│
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── HomeViewModel.swift
│   ├── BalancesViewModel.swift
│   ├── ProfileViewModel.swift
│   └── AddTransactionViewModel.swift
│
└── Views/
    ├── AuthView.swift
    ├── HomeView.swift
    ├── BalancesView.swift
    ├── ProfileView.swift
    ├── AddTransactionView.swift
    ├── MainTabView.swift            # Tab bar + sheet presentation
    └── SharedViews.swift            # Reusable components (TopBar, FAB, SegmentControl, etc.)
```

---

## Requirements

| Requirement | Version |
|------------|---------|
| Xcode | 16.0+ |
| iOS Deployment Target | 17.0+ |
| Swift | 5.9+ |
| Device | iPhone (any size) |

---

## Setup & Installation

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/tuf-mm.git
cd tuf-mm
```

### 2. Open in Xcode

```bash
open tuf_mm/tuf_mm.xcodeproj
```

Or open Xcode manually and select **Open a Project or File**, then navigate to `tuf_mm.xcodeproj`.

### 3. Select a simulator or device

In the Xcode toolbar, choose any iPhone simulator (iPhone 15 Pro or later recommended) or connect a real device.

### 4. Build and run

Press **⌘R** or click the **▶ Run** button.

> No dependencies, CocoaPods, or Swift Package Manager packages required. The project builds immediately out of the box.

---

## First Launch

1. **Create an account** — tap "Sign Up", enter your name, email, and a password (min 8 characters)
2. **Enable currencies** — go to the Balances tab and toggle on the currencies you use
3. **Add your first transaction** — tap the **+** button on any screen
4. **Flip the home card** — tap the card on the Home screen to see this month's summary
5. **Toggle dark/light mode** — go to Profile → Dark Mode toggle

---

## Data Storage

All data is stored locally on the device using `UserDefaults` with JSON encoding. No network requests are made. Data persists across app launches.

| Key | Contents |
|-----|---------|
| `lr_currentUser` | Signed-in user |
| `lr_registeredUsers` | All registered accounts |
| `lr_transactions` | All transactions |
| `lr_currencies` | Currency enable/favourite state |
| `lr_isDarkMode` | Appearance preference |

---

## License

This project is for educational purposes.
