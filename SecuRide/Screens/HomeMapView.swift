////
////  HomeMapView.swift
////  SecuRide
////
////  Created by Ashok Saravanan on 8/16/24.
////
//
//import SwiftUI
//import MapKit
//
//struct HomeMapView: View {
//    var body: some View {
//        Map {
//            Marker("San Francisco City Hall", coordinate: cityHallLocation)
//                .tint(.orange)
//            Marker("San Francisco Public Library", coordinate: publicLibraryLocation)
//                .tint(.blue)
//            Annotation("Diller Civic Center Playground", coordinate: playgroundLocation) {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 5)
//                        .fill(Color.yellow)
//                    Text("🛝")
//                        .padding(5)
//                }
//            }
//        }
//        .mapControlVisibility(.hidden)
//    }
//}
//
//#Preview {
//    HomeMapView()
//}
