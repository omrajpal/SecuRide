import SwiftUI
import UberCore

struct UberLoginButton: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let scopes: [UberScope] = [.profile, .places, .request]
        let loginManager = LoginManager(loginType: .native)
        let loginButton = LoginButton(frame: .zero, scopes: scopes, loginManager: loginManager)
        loginButton.presentingViewController = viewController
        loginButton.delegate = context.coordinator
        
        viewController.view.addSubview(loginButton)
        viewController.view.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        loginButton.center = viewController.view.center
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the UI if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        func loginButton(_ button: LoginButton, didLogoutWithSuccess success: Bool) {
            print("Logout successful: \(success)")
        }
        
        func loginButton(_ button: LoginButton, didCompleteLoginWithToken accessToken: AccessToken?, error: NSError?) {
            if let token = accessToken {
                print("Access Token: \(token.tokenString)")
            } else if let error = error {
                print("Login error: \(error.description)")
            }
        }
    }
}
