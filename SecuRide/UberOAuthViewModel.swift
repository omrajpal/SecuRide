import Foundation
import UIKit
import Combine

class UberOAuthViewModel: ObservableObject {
    @Published var accessToken: String?
    @Published var isLoggedIn: Bool = false
    
    private let clientID = "AamFhQ37nHHGfBa47yTuKTEiZ-RlEcvB"
    private let clientSecret = "lVTSdtyIjW_RP8INJEoKLFWCWjCWY_HbIbgENpmh"
    private let redirectURI = "com.asaravan.securide://oauth/consumer"
    
    func login() {
        guard let authURL = URL(string: "https://login.uber.com/oauth/v2/authorize?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)") else {
            print("Error: Invalid authorization URL")
            return
        }
        UIApplication.shared.open(authURL)
        print("Opening URL: \(authURL)")
    }
    
    func handleRedirectURL(_ url: URL) {
        print("Handling redirect URL: \(url)")
        
        guard let code = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "code" })?
                .value else {
            print("Error: Authorization code not found")
            return
        }
        print("Authorization code: \(code)")
        fetchAccessToken(with: code)
    }
    
    private func fetchAccessToken(with code: String) {
        guard let tokenURL = URL(string: "https://login.uber.com/oauth/v2/token") else {
            print("Error: Invalid token URL")
            return
        }
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        
        let params = [
            "client_secret": clientSecret,
            "client_id": clientID,
            "grant_type": "authorization_code",
            "redirect_uri": redirectURI,
            "code": code
        ]
        
        request.httpBody = params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching access token: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                return
            }
            
            print("Received data: \(String(describing: String(data: data, encoding: .utf8)))")
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let accessToken = json["access_token"] as? String {
                DispatchQueue.main.async {
                    print("Access token: \(accessToken)")
                    self?.accessToken = accessToken
                    self?.isLoggedIn = true
                }
            } else {
                print("Error: Unable to parse JSON response")
            }
        }.resume()
    }
}
