//
//  SecuRideApp.swift
//  SecuRide
//
//  Created by Om Rajpal on 7/14/24.
//

import SwiftUI
import GoogleSignIn
import SwiftUI

@main
struct SecuRideApp: App {
    @State var isActive: Bool = false
    
    var body: some Scene {
        WindowGroup {
//            ZStack {
//                if self.isActive {
//                    AppView()
//                        .onOpenURL { url in
//                          GIDSignIn.sharedInstance.handle(url)
//                        }
//                } else {
//                    Rectangle()
//                        .background(Color.black)
//    //                Image("LiyickyLogoWhite")
//    //                    .resizable()
//    //                    .scaledToFit()
//    //                    .frame(width: 300, height: 300)
//                }
//            }
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    withAnimation {
//                        self.isActive = true
//                    }
//                }
//            }
            AppView()
                .onOpenURL { url in
                  GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
