//
//  SignInViewModel.swift
//  SecuRide
//
//  Created by Ashok Saravanan on 7/28/24.
//

import Foundation
import GoogleSignIn


class SignInViewModel: ObservableObject {
    
    func signInWithGoogle() async throws -> AppUser {
        let signInGoogle = SignInGoogle()
        let googleResult = try await signInGoogle.startSignInWithGoogleFlow()
        return try await AuthManager.shared.signInWithGoogle(idToken: googleResult.idToken)
    }
}
