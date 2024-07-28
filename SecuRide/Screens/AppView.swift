import SwiftUI
import Foundation

struct AppView: View {
    @State var appUser: AppUser? = nil
    @State var isLoading: Bool = true
    @State var showGoogleSignIn: Bool = false
    @State var isSigningIn: Bool = false

    var body: some View {
        ZStack {
            if isLoading {
                LoadingView(message: "Loading...")
            } else if isSigningIn {
                LoadingView(message: "Signing you in...")
            } else if showGoogleSignIn {
                GoogleSignInViewRepresentable { result in
                    switch result {
                    case .success(let signInResult):
                        Task {
                            self.isSigningIn = true
                            do {
                                self.appUser = try await AuthManager.shared.signInWithGoogle(idToken: signInResult.idToken)
                                self.showGoogleSignIn = false
                            } catch {
                                print("Failed to sign in with Google: \(error)")
                                // Handle sign-in failure
                            }
                            self.isSigningIn = false
                        }
                    case .failure(let error):
                        print("Google Sign-In failed: \(error)")
                        // Handle sign-in failure
                        self.showGoogleSignIn = false
                    }
                }
            } else {
                if let _ = appUser {
                    TabView {
                        HistoryView()
                            .tabItem {
                                Label("History", systemImage: "clock")
                            }
                        ContentView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        AccountView(appUser: $appUser)
                            .tabItem {
                                Label("Account", systemImage: "person")
                            }
                    }
                } else {
                    Button("Sign in with Google") {
                        showGoogleSignIn = true
                    }
                }
            }
        }
        .onAppear {
            fetchCurrentSession()
        }
    }

    private func fetchCurrentSession() {
        Task {
            do {
                self.appUser = try await AuthManager.shared.getCurrentSession()
            } catch {
                print("Failed to fetch session: \(error)")
            }
            self.isLoading = false
        }
    }
}

#Preview {
    AppView()
}
