//
//  AuthManager.swift
//  SecuRide
//
//  Created by Ashok Saravanan on 7/28/24.
//

import Foundation
import Supabase

struct AppUser {
    let uid: String
    let email: String?
}


class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://bdhvlsqtkvhbukvbnsfl.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJkaHZsc3F0a3ZoYnVrdmJuc2ZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjEzOTYxNjAsImV4cCI6MjAzNjk3MjE2MH0.CWZYcMb1F3OjQfpDtGeSVUIj7MIj4EdIVZ1YN4yvyKQ",
        options: .init(
          global: .init(logger: AppLogger())
        )
      )
    
    func getCurrentSession() async throws -> AppUser {
        let session = try await client.auth.session
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func signInWithGoogle(idToken: String) async throws -> AppUser {
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .google, idToken: idToken))
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
        
    }
}





