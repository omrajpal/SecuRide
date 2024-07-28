//
//  GoogleSignInViewModel.swift
//  SecuRide
//
//  Created by Ashok Saravanan on 7/28/24.
//

import Foundation
import GoogleSignIn


class SignInViewModel: ObservableObject {
    
    
    func signInWithGoogle() {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { signInResult, error in
              guard let result = signInResult else {
                // Inspect error
                return
              }
              // If sign in succeeded, display the app's main content View.
            }
          )
    }
}
