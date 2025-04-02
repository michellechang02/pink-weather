import SwiftUI

struct LocationDetailView: View {
    let location: Location
    @StateObject private var weatherManager = WeatherManager()
    @EnvironmentObject private var locationManager: LocationManager
    
    
    private let primaryColor = Color(red: 0.95, green: 0.55, blue: 0.75)
    private let secondaryColor = Color(red: 0.85, green: 0.6, blue: 0.95)
    private let accentColor = Color(red: 1.0, green: 0.85, blue: 0.9)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Location header with favorite button
                HStack {
                    Text(location.name)
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(primaryColor)
                    
                    Spacer()
                    
                    Button(action: {
                        locationManager.toggleFavorite(for: location)
                    }) {
                        Image(systemName: locationManager.isFavorite(location: location) ? "heart.fill" : "heart")
                            .font(.title)
                            .foregroundColor(primaryColor)
                    }
                }
                
                // Loading view
                if weatherManager.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                            .progressViewStyle(CircularProgressViewStyle(tint: primaryColor))
                        Spacer()
                    }
                } else if let current = weatherManager.currentWeather {
                    // Current weather section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("CURRENT WEATHER")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(primaryColor)
                            .tracking(1.5)
                            .padding(.bottom, 5)
                        
                        HStack {
                            WeatherDataView(
                                title: "Temperature",
                                value: "\(Int(current.temperature))°",
                                icon: "thermometer",
                                primaryColor: primaryColor,
                                secondaryColor: secondaryColor
                            )
                            
                            Spacer()
                            
                            WeatherDataView(
                                title: "Precipitation",
                                value: String(format: "%.1f mm", current.precipitation),
                                icon: "cloud.rain",
                                primaryColor: primaryColor,
                                secondaryColor: secondaryColor
                            )
                            
                            Spacer()
                            
                            WeatherDataView(
                                title: "Chance of Rain",
                                value: "\(Int(current.precipitationProbability))%",
                                icon: "drop.fill",
                                primaryColor: primaryColor,
                                secondaryColor: secondaryColor
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(accentColor.opacity(0.3))
                    )
                    
                    // Hourly forecast if available
                    if let hourly = weatherManager.hourlyWeather {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("HOURLY FORECAST")
                                    .font(.system(size: 16, weight: .heavy))
                                    .foregroundColor(primaryColor)
                                    .tracking(1.5)
                                
                                Spacer()
                                
                                Image(systemName: "clock.fill")
                                    .foregroundColor(primaryColor)
                            }
                            
                            ScrollView {
                                LazyVGrid(columns: [
                                    GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 16)
                                ], spacing: 16) {
                                    ForEach(0..<min(24, hourly.time.count), id: \.self) { index in
                                        VStack(spacing: 8) {
                                            Text(formatHourString(hourly.time[index]))
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(secondaryColor)
                                            
                                            Text("\(Int(hourly.temperature[index]))°")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(primaryColor)
                                            
                                            Image(systemName: "cloud.rain")
                                                .foregroundColor(secondaryColor)
                                            
                                            Text("\(Int(hourly.precipitationProbability[index]))%")
                                                .font(.caption)
                                                .foregroundColor(secondaryColor)
                                        }
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 14)
                                        .background(accentColor.opacity(0.2))
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(primaryColor.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                            .frame(maxHeight: 300) // Limit the height of the scroll view
                        }
                        .padding(.top)
                    }
                }
                
                if !weatherManager.errorMessage.isEmpty {
                    Text(weatherManager.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            weatherManager.fetchWeather(for: location)
        }
    }
    
    private func formatHourString(_ timeString: String) -> String {
        // Format time string from API (2025-03-27T12:00) to just show hour (12:00)
        let components = timeString.split(separator: "T")
        if components.count > 1 {
            return String(components[1])
        }
        return timeString
    }
}

struct WeatherDataView: View {
    let title: String
    let value: String
    let icon: String
    let primaryColor: Color
    let secondaryColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(primaryColor)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(primaryColor)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(secondaryColor)
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 80)
        .padding(.vertical, 8)
    }
} 