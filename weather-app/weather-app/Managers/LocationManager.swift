import Foundation
import CoreLocation
import SwiftUI

class LocationManager: ObservableObject {
    @Published var currentLocation: Location?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var favorites: [Location] = []
    
    private let geocoder = CLGeocoder()
    private let storageManager = StorageManager()
    
    init() {
        loadFavorites()
    }
    
    func geocodeLocation(query: String) {
        isLoading = true
        errorMessage = ""
        
        // Create URL for OpenStreetMap Nominatim API
        var urlComponents = URLComponents(string: "https://nominatim.openstreetmap.org/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "addressdetails", value: "1"),
            URLQueryItem(name: "limit", value: "1")
        ]
        
        guard let url = urlComponents?.url else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        // Create request with proper headers
        var request = URLRequest(url: url)
        request.addValue("WeatherApp/1.0", forHTTPHeaderField: "User-Agent") // Required by Nominatim API
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Error finding location: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    // Parse the JSON response
                    let locations = try JSONDecoder().decode([GeocodingResponse].self, from: data)
                    
                    guard let firstLocation = locations.first else {
                        self?.errorMessage = "No location found for that address"
                        return
                    }
                    
                    // Create location from the geocoding response
                    let locationName = firstLocation.displayName
                    
                    // Create and set the current location
                    var newLocation = Location(
                        name: locationName,
                        latitude: Double(firstLocation.lat) ?? 0.0,
                        longitude: Double(firstLocation.lon) ?? 0.0
                    )
                    
                    // Check if it's a favorite
                    newLocation.isFavorite = self?.isFavorite(location: newLocation) ?? false
                    
                    // Set current location which will trigger navigation
                    self?.currentLocation = newLocation
                } catch {
                    self?.errorMessage = "Error parsing location data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func toggleFavorite(for location: Location) {
        if let index = favorites.firstIndex(where: { $0 == location }) {
            favorites.remove(at: index)
        } else {
            var locationToSave = location
            locationToSave.isFavorite = true
            favorites.append(locationToSave)
        }
        
        saveFavorites()
    }
    
    func removeFavorite(at offsets: IndexSet) {
        favorites.remove(atOffsets: offsets)
        saveFavorites()
    }
    
    func isFavorite(location: Location) -> Bool {
        return favorites.contains(where: { $0 == location })
    }
    
    private func saveFavorites() {
        storageManager.saveFavorites(favorites)
    }
    
    private func loadFavorites() {
        favorites = storageManager.loadFavorites()
    }
}


