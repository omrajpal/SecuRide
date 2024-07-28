// SignInGoogle.swift
// SecuRide
//
// Created by Ashok Saravanan on 7/28/24.
//

import Foundation
import GoogleSignIn
import UIKit

struct SignInGoogleResult {
    let idToken: String
}

class SignInGoogle {
    func startSignInWithGoogleFlow() async throws -> SignInGoogleResult {
        return try await withCheckedThrowingContinuation { continuation in
            signInWithGoogleFlow { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func signInWithGoogleFlow(completion: @escaping (Result<SignInGoogleResult, Error>) -> Void) {
        // Get the top view controller
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(NSError(domain: "TopViewControllerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to find top view controller"])))
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = signInResult?.user, let idToken = user.idToken else {
                completion(.failure(NSError(domain: "SignInError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get user or ID token"])))
                return
            }
            
            completion(.success(SignInGoogleResult(idToken: idToken.tokenString)))
        }
    }
}

// Extension to get the top view controller
extension UIApplication {
    static func getTopViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .first?.windows
        .filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return getTopViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return getTopViewController(base: selected)
                }
            }
            if let presented = base?.presentedViewController {
                return getTopViewController(base: presented)
            }
            return base
        }
}
