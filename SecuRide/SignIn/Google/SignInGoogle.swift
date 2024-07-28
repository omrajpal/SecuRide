import Foundation
import GoogleSignIn
import SwiftUI

struct SignInGoogleResult {
    let idToken: String
}

class SignInGoogle {
    func startSignInWithGoogleFlow() async throws -> SignInGoogleResult {
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                let signInView = GoogleSignInViewRepresentable { result in
                    continuation.resume(with: result)
                }
                let controller = UIHostingController(rootView: signInView)
                if let topVC = getTopViewController() {
                    topVC.present(controller, animated: true)
                }
            }
        }
    }
    
    @MainActor
    private func getTopViewController() -> UIViewController? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first?.rootViewController
    }
}
