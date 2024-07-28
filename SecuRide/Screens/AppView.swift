import SwiftUI
import Foundation

struct AppView: View {
    @State var appUser: AppUser? = nil
    @State var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
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
                    GoogleAuthView(appUser: $appUser)
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
