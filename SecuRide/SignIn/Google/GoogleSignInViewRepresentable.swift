import Foundation
import SwiftUI
import GoogleSignIn

struct GoogleSignInViewRepresentable: UIViewControllerRepresentable {
    var completion: (Result<SignInGoogleResult, Error>) -> Void

    class Coordinator: NSObject {
        var parent: GoogleSignInViewRepresentable
        var completion: (Result<SignInGoogleResult, Error>) -> Void

        init(parent: GoogleSignInViewRepresentable, completion: @escaping (Result<SignInGoogleResult, Error>) -> Void) {
            self.parent = parent
            self.completion = completion
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, completion: completion)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = GoogleSignInViewController()
        viewController.completion = context.coordinator.completion
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class GoogleSignInViewController: UIViewController {
    var completion: ((Result<SignInGoogleResult, Error>) -> Void)?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Presenting Google Sign-In
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                self.completion?(.failure(error))
                return
            }
            
            guard let user = signInResult?.user, let idToken = user.idToken else {
                self.completion?(.failure(NSError(domain: "SignInError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get user or ID token"])))
                return
            }
            
            self.completion?(.success(SignInGoogleResult(idToken: idToken.tokenString)))
        }
    }
}
