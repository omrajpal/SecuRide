//
//  SecuRideApp.swift
//  SecuRide
//
//  Created by Om Rajpal on 7/14/24.
//

import SwiftUI
import GoogleSignIn
import SwiftUI

@main
struct SecuRideApp: App {
    var body: some Scene {
        WindowGroup {
//            AppView(appUser: .constant(nil))
//                .onOpenURL { url in
//                  GIDSignIn.sharedInstance.handle(url)
//                }
            HomeView()
        }
    }
}
