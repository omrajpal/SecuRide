//
//  LoadingView.swift
//  SecuRide
//
//  Created by Ashok Saravanan on 7/28/24.
//

import SwiftUI

struct LoadingView: View {
    var message: String
    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text(message)
                .padding(.top, 10)
        }
    }
}

#Preview {
    LoadingView(message: "Loading")
}
