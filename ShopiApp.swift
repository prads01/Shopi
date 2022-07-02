//
//  ShopiApp.swift
//  Shopi
//
//  Created by Praduyt Sen on 15/08/20.
//

import SwiftUI
import Firebase

@main
struct ShopiApp: App {
    @UIApplicationDelegateAdaptor(Delegate.self) var delegte
    
    var body: some Scene {
        WindowGroup {
            OnBoardingView()
                .preferredColorScheme(.light)
        }
    }
}


// Connecting to Firebase...

class Delegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
