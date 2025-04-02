import Foundation

class StorageManager {
    private let favoritesKey = "favoriteLocations"
    
    // Using FileManager for persistent storage (as required to not use UserDefaults)
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var favoritesURL: URL {
        getDocumentsDirectory().appendingPathComponent(favoritesKey).appendingPathExtension("json")
    }
    
    func saveFavorites(_ favorites: [Location]) {
        do {
            let data = try JSONEncoder().encode(favorites)
            try data.write(to: favoritesURL)
        } catch {
            print("Error saving favorites: \(error)")
        }
    }
    
    func loadFavorites() -> [Location] {
        do {
            let data = try Data(contentsOf: favoritesURL)
            return try JSONDecoder().decode([Location].self, from: data)
        } catch {
            print("Error loading favorites: \(error)")
            return []
        }
    }
} 