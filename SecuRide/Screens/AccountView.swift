//
//  AccountView.swift
//  SecuRide
//
//  Created by Ashok Saravanan on 7/28/24.
//

import SwiftUI

struct AccountView: View {
    @Binding var appUser: AppUser?
    
    var body: some View {
        if let appUser = appUser {
            VStack {
                Text(appUser.uid)
                Text(appUser.email ?? "No email")
                Button {
                    Task {
                        do {
                            try await AuthManager.shared.signOut()
                            self.appUser = nil
                        } catch {
                            print("unable to sign out")
                        }
                    }
                } label: {
                    Text("Sign Out")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }
            
        }
    }
}

#Preview {
    AccountView(appUser: .constant(AppUser(uid: "1234", email: "hello@gmail.com")))
}
