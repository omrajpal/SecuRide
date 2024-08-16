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
    @State private var searchCompleter = MKLocalSearchCompleter()
    @State private var searchResults = [MKLocalSearchCompletion]()

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 32, height: 5)
                .foregroundColor(Color(UIColor.tertiaryLabel))

            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a place or address", text: $search, onEditingChanged: { _ in
                    searchCompleter.queryFragment = search
                })
                    .foregroundColor(.primary)
                Image(systemName: "mic.fill")
            }
            .foregroundColor(Color(UIColor.tertiaryLabel))
            .padding(12)
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            .cornerRadius(12)

            List(searchResults, id: \.self) { completion in
                Button(action: {
                    search(for: completion)
                }) {
                    Text(completion.title)
                        .foregroundColor(.primary)
                    Text(completion.subtitle)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(24)
        .padding(.top, -16)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .onAppear {
            searchCompleter.delegate = SearchCompleterDelegate(results: $searchResults)
        }
    }

    func search(for completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            guard let strongSelf = self, let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let mapItem = response.mapItems.first {
                let coordinate = mapItem.placemark.coordinate
                strongSelf.centerCoordinate = coordinate
                strongSelf.mapViewCoordinator?.calculateRoute(from: locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(), to: coordinate)
            }
        }
    }
}

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    @Binding var results: [MKLocalSearchCompletion]

    init(results: Binding<[MKLocalSearchCompletion]>) {
        _results = results
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

struct Controls: View {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var showingInfoView: Bool
    var mapViewCoordinator: MapView.Coordinator?

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
        Button(action: {
                    mapViewCoordinator?.calculateRoute(from: LocationManager.shared.lastLocation?.coordinate ?? CLLocationCoordinate2D(), to: centerCoordinate)
                }) {
                    Image(systemName: "location.fill")
                }
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
    @State private var shouldCenterOnUserLocation = true

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
            if self.parent.shouldCenterOnUserLocation {
                self.parent.centerCoordinate = location.coordinate
                let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                self.mapView?.setRegion(region, animated: true)
                self.parent.shouldCenterOnUserLocation = false // Only center on first update
            }
        }
        
        func calculateRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
            let originPlacemark = MKPlacemark(coordinate: origin)
            let destinationPlacemark = MKPlacemark(coordinate: destination)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: originPlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { [weak self] (response, error) in
                guard let strongSelf = self else { return }
                if let route = response?.routes.first {
                    strongSelf.mapView?.addOverlay(route.polyline)
                    let region = MKCoordinateRegion(route.polyline.boundingMapRect)
                    strongSelf.mapView?.setRegion(region, animated: true)
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
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
