//
//  HomeView.swift
//  SecuRide
//
//  Created by Om Rajpal on 7/28/24.
//

import SwiftUI

struct HomeView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                // create tabs here instead of in the other view.
                SearchView()
            } else {
                Rectangle()
                    .background(Color.black)
//                Image("LiyickyLogoWhite")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 300, height: 300)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
