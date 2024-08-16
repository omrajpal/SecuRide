//
//  SearchView.swift
//  SecuRide
//
//  Created by Ashok Saravanan on 8/16/24.
//
import SwiftUI
import MapKit

struct SearchView: View {
    @State private var search = ""
    @State private var isSearching = false
    @State private var searchResults: [MKMapItem] = []
    
    var body: some View {
        VStack {
            Text("Where are you headed?")
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a place or address", text: $search)
                    .onSubmit {
                        searchPlaces()
                    }
                    .foregroundColor(.primary)
                Image(systemName: "mic.fill")
            }
            .padding(.bottom, 8)
            
            if isSearching {
                ProgressView("Searching...")
                    .padding()
            }
            
            List(searchResults, id: \.self) { item in
                VStack(alignment: .leading) {
                    Text(item.name ?? "Unknown Place")
                        .font(.headline)
                    if let location = item.placemark.location {
                        Text("\(location.coordinate.latitude), \(location.coordinate.longitude)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
    }
    
    private func searchPlaces() {
        isSearching = true
        searchResults.removeAll()
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = search

        let localSearch = MKLocalSearch(request: searchRequest)
        
        DispatchQueue.global(qos: .userInitiated).async {
            localSearch.start { (response, error) in
                DispatchQueue.main.async {
                    isSearching = false
                    
                    guard let response = response else {
                        print("Search failed: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    searchResults = response.mapItems
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
