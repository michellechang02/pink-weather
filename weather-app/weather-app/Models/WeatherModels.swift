import Foundation
import CoreLocation

// Location model with Codable for storage
struct Location: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var isFavorite: Bool = false
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Weather data models
struct WeatherResponse: Decodable {
    let current: CurrentWeather
    let hourly: HourlyWeather
    
    enum CodingKeys: String, CodingKey {
        case current
        case hourly
    }
}

// Current weather model
struct CurrentWeather: Decodable {
    let temperature: Double
    let precipitation: Double
    let precipitationProbability: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case precipitation
        case precipitationProbability = "precipitation_probability"
    }
}

// Hourly weather model
struct HourlyWeather: Decodable {
    let time: [String]
    let temperature: [Double]
    let precipitation: [Double]
    let precipitationProbability: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case precipitation
        case precipitationProbability = "precipitation_probability"
    }
} 

// Geocoding response model
struct GeocodingResponse: Codable {
    let displayName: String
    let lat: String
    let lon: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case lat, lon
    }
} 