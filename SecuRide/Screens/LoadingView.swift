//
//  LoadingView.swift
//  SecuRide
//
//  Created by Ashok Saravanan on 7/28/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text("Loading...")
        }
    }
}

#Preview {
    LoadingView()
}
