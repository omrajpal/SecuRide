//
//  SecuRideApp.swift
//  SecuRide
//
//  Created by Om Rajpal on 7/14/24.
//

import SwiftUI
import UberCore

@main
struct SecuRideApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    @available(iOS 9, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let handledUberURL = UberAppDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] as Any)

        return handledUberURL
    }
        
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handledUberURL = UberAppDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)

        return handledUberURL
    }
}
