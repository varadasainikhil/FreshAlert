//
//  FreshAlertApp.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/21/25.
//
import FirebaseCore
import SwiftData
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct FreshAlertApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            EntryView()
        }
        .modelContainer(for: [GroupedProducts.self, Item.self])
    }
}
