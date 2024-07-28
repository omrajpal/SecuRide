//
//  ContentView.swift
//  SecuRide
//
//  Created by Om Rajpal on 7/14/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var showingInfoView = false

    var body: some View {
        NavigationView {
            ZStack {
                MapView(centerCoordinate: $centerCoordinate)

                VStack {
                    HStack {
                        Spacer()
                        Controls(centerCoordinate: $centerCoordinate, showingInfoView: $showingInfoView)
                    }

                    Spacer()
                    Sheet(centerCoordinate: $centerCoordinate)
                }
            }
            .cornerRadius(24)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingInfoView) {
                InfoView()
            }
        }
    }
}

struct InfoView: View {
    var body: some View {
        VStack {
            Text("Information")
                .font(.largeTitle)
                .padding()

            Text("This is the InfoView.")
                .padding()

            Spacer()
        }
    }
}

struct Sheet: View {
    @State var search = ""
    @Binding var centerCoordinate: CLLocationCoordinate2D

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 32, height: 5)
                .foregroundColor(Color(UIColor.tertiaryLabel))

            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a place or address", text: $search, onCommit: {
                    performSearch()
                })
                    .foregroundColor(.primary)
                Image(systemName: "mic.fill")
            }
            .foregroundColor(Color(UIColor.tertiaryLabel))
            .padding(12)
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            .cornerRadius(12)
        }
        .padding(24)
        .padding(.top, -16)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    func performSearch() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = search
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let mapItem = response.mapItems.first {
                let coordinate = mapItem.placemark.coordinate
                centerCoordinate = coordinate
            }
        }
    }
}

struct Controls: View {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var showingInfoView: Bool

    var body: some View {
        VStack(spacing: 6) {
            VStack(spacing: 12) {
                Button(action: {
                    showingInfoView = true
                }) {
                    Image(systemName: "info.circle")
                }
                Divider()
                Button(action: {
                    // Action to bring map back to user's current location
                    if let location = LocationManager.shared.lastLocation {
                        centerCoordinate = location.coordinate
                    }
                }) {
                    Image(systemName: "location.fill")
                }
            }
            .frame(width: 40)
            .padding(.vertical, 12)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(8)

            Button(action: {
                // Binoculars button action
            }) {
                Image(systemName: "binoculars.fill")
            }
            .frame(width: 40)
            .padding(.vertical, 12)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(8)
        }
        .font(.system(size: 20))
        .foregroundColor(.blue)
        .padding()
        .shadow(color: Color(UIColor.black.withAlphaComponent(0.1)), radius: 4)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    @Published var lastLocation: CLLocation? = nil

    private override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first
    }
}

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    let locationManager = CLLocationManager()

    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapView
        var mapView: MKMapView?

        init(parent: MapView) {
            self.parent = parent
            super.init()
            self.parent.locationManager.delegate = self
            self.parent.locationManager.requestWhenInUseAuthorization()
            self.parent.locationManager.startUpdatingLocation()
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            self.parent.centerCoordinate = location.coordinate
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView?.setRegion(region, animated: true)
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        context.coordinator.mapView = mapView
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }
}
