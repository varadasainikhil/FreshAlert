# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
FreshAlert is an iOS app built with SwiftUI and Firebase that helps users track food product expiration dates. The app features user authentication (including Sign in with Apple) and product management with SwiftData for local storage.

## Architecture
- **Entry Point**: `FreshAlertApp.swift` - Main app with Firebase configuration and SwiftData model container
- **Authentication Flow**: `EntryView.swift` determines if user sees `SignUpView` or `AuthenticatedView`
- **Main App**: `AuthenticatedView.swift` - TabView with Home and Profile tabs
- **Data Model**: `Product.swift` - SwiftData model for product storage with barcode, name, description, dates, and optional image
- **MVVM Pattern**: ViewModels in `ViewModel/` folder handle business logic for each view

## Key Dependencies
- **Firebase**: Analytics, Auth, Firestore for user authentication and data sync
- **SwiftData**: Local data persistence for Product model
- **SwiftUI**: UI framework with tab-based navigation

## Development Commands
```bash
# Build the project
xcodebuild -scheme FreshAlert -configuration Debug build

# Build for release
xcodebuild -scheme FreshAlert -configuration Release build

# Clean build folder
xcodebuild -scheme FreshAlert clean

# Build and run on simulator (requires simulator to be open)
xcodebuild -scheme FreshAlert -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## File Structure
- `FreshAlert/` - Main source directory
  - `Views/` - SwiftUI views (Entry, Authenticated, Home, Login, SignUp, Profile, AddProduct)
  - `ViewModel/` - MVVM view models for business logic
  - `Models/` - Data models (Product with SwiftData)
  - `Custom Components/` - Reusable UI components (CustomTextField, CustomSecureField)
  - `TODOS.swift` - Project roadmap and planned features

## Planned Features (from TODOS.swift)
- CRUD operations for products
- CloudKit integration for sync
- Expiration notifications (7-day warning)
- Visual indicators for expired (red) and soon-to-expire (orange) products
- Product API integration for automatic product info
- Email verification and password reset