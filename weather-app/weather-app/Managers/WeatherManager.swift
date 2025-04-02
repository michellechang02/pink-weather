import Foundation

class WeatherManager: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var hourlyWeather: HourlyWeather?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    func fetchWeather(for location: Location) {
        isLoading = true
        errorMessage = ""
        
        // Using the Open-Meteo API for weather data
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&current=temperature_2m,precipitation,precipitation_probability&hourly=temperature_2m,precipitation,precipitation_probability&forecast_days=1&temperature_unit=fahrenheit"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Error fetching weather: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    self?.currentWeather = weatherResponse.current
                    self?.hourlyWeather = weatherResponse.hourly
                } catch {
                    self?.errorMessage = "Error decoding weather data: \(error.localizedDescription)"
                    print("JSON decode error: \(error)")
                }
            }
        }.resume()
    }
    
    // Helper method to get current hour index
    private func getCurrentHourIndex(from times: [String]) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        let now = Date()
        
        for (index, timeString) in times.enumerated() {
            if let date = dateFormatter.date(from: timeString) {
                if date > now {
                    // Return the previous index or 0 if this is the first element
                    return max(0, index - 1)
                }
            }
        }
        
        return nil
    }
} 