//
//  AppView.swift
//  SecuRide
//
//  Created by Om Rajpal on 7/21/24.
//


import SwiftUI
import Foundation

struct AppView: View {
    @State var appUser: AppUser? = nil
    
    var body: some View {
        ZStack {
            if let _ = appUser {
                TabView {
                    HistoryView()
                        .tabItem {
                            Label("History", systemImage: "tray")
                        }
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "home")
                        }
                    AccountView()
                        .tabItem {
                            Label("Account", systemImage: "person")
                        }
                }
            } else {
                GoogleAuthView(appUser: $appUser)
            }
        }.onAppear {
            Task {
                self.appUser = try await AuthManager.shared.getCurrentSession()
            }
        }
    }
}

#Preview {
    AppView()
}
