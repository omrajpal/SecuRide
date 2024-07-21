import SwiftUI

extension UIApplication {
    var currentRootViewController: UIViewController? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
    }
}

struct UberLoginButton: View {
    @ObservedObject var uberLoginManager = UberLoginManager.shared
    
    var body: some View {
        Button(action: {
            if uberLoginManager.isLoggedIn {
                uberLoginManager.logout()
            } else {
                if let rootVC = UIApplication.shared.currentRootViewController {
                    uberLoginManager.login(presentingViewController: rootVC)
                }
            }
        }) {
            Text(uberLoginManager.isLoggedIn ? "Logout from Uber" : "Login with Uber")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .frame(height: 50)
        .padding()
    }
}
//import SwiftUI
//
//struct UberLoginButton: View {
//    @ObservedObject var viewModel = UberOAuthViewModel()
//    
//    var body: some View {
//        Button(action: {
//            if viewModel.isLoggedIn {
//                viewModel.accessToken = nil
//                viewModel.isLoggedIn = false
//            } else {
//                viewModel.login()
//            }
//        }) {
//            Text(viewModel.isLoggedIn ? "Logout from Uber" : "Login with Uber")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//        }
//        .frame(height: 50)
//        .padding()
//    }
//}
