import UberCore
import UberRides
import Combine

class UberLoginManager: ObservableObject {
    static let shared = UberLoginManager()
    
    @Published var isLoggedIn: Bool = false
    
    private init() {}
    
    func login(presentingViewController: UIViewController) {
        let loginManager = LoginManager()
        loginManager.login(requestedScopes: [.request, .profile, .allTrips], presentingViewController: presentingViewController) { [weak self] accessToken, error in
            if let accessToken = accessToken {
                print(accessToken)
                // Successfully logged in
                self?.isLoggedIn = true
                // Save the access token if needed
            } else {
                // Handle error
                print("Error logging in: \(error?.debugDescription ?? "Unknown error")")
            }
        }
    }
    
    func logout() {
        // Clear the access token or perform necessary logout operations
        isLoggedIn = false
    }
}
