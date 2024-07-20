//
//  ContentView.swift
//  SecuRide
//
//  Created by Om Rajpal on 7/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            UberLoginButton()  // Add the Uber login button here
                .frame(height: 50)  // Optionally set height for the button
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
