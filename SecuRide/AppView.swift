//
//  AppView.swift
//  SecuRide
//
//  Created by Om Rajpal on 7/21/24.
//


import SwiftUI

struct AppView: View {
    @Binding var appUser: AppUser?

  var body: some View {
      ZStack {
          if let appUser = appUser {
              HomeView()
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
    AppView(appUser: .constant(nil))
}
