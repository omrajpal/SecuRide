//
//  GoogleAuthView.swift
//  SecuRide
//
//  Created by Ashok Saravanan on 7/28/24.
//

import SwiftUI

struct GoogleAuthView: View {
    @StateObject var viewModel = SignInViewModel()
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        VStack(spacing: 40) {
            Button {
                Task {
                    do {
                        let appUser = try await viewModel.signInWithGoogle()
                        self.appUser = appUser
                    } catch {
                        print("error signing in.")
                    }
                }
            } label: {
                Text("Sign in with Google")
                    .foregroundColor(.blue)
            }
            
        }
    }
}
