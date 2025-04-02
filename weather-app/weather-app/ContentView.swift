//
//  ContentView.swift
//  weather-app
//
//  Created by Michelle Chang on 3/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var locationInput = ""
    @EnvironmentObject private var locationManager: LocationManager
    
    private let primaryColor = Color(red: 0.95, green: 0.55, blue: 0.75)
    private let secondaryColor = Color(red: 0.85, green: 0.6, blue: 0.95)
    private let accentColor = Color(red: 1.0, green: 0.85, blue: 0.9)
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Light background
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 28) {
                    // Header
                    headerView

                    // Developer name
                    developerView
                    
                    // Search bar
                    searchBarView
                    
                    // Weather button
                    weatherButtonView
                    
                    // Loading indicator
                    if locationManager.isLoading {
                        loadingView
                    }
                    
                    // Error message
                    if !locationManager.errorMessage.isEmpty {
                        errorView
                    }
                    
                    // Favorites section
                    if !locationManager.favorites.isEmpty {
                        favoritesView
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .onChange(of: locationInput) { _ in
                locationManager.errorMessage = ""
            }
            .onSubmit {
                if !locationInput.isEmpty {
                    locationManager.geocodeLocation(query: locationInput)
                }
            }
            .navigationBarItems(trailing: favoriteButton)
            .navigationDestination(for: Location.self) { location in
                LocationDetailView(location: location)
                    .environmentObject(locationManager)
            }
        }
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let location = newLocation {
                navigationPath.append(location)
            }
        }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Component Views
    
    private var headerView: some View {
        Text("pink weather")
            .font(.system(size: 40, weight: .black))
            .foregroundColor(primaryColor)
            .padding(.top, 20)
    }

    private var developerView: some View {
        Text("by mɪˈʃɛl")
            .font(.system(size: 16, weight: .black))
            .foregroundColor(primaryColor)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(primaryColor)
                .padding(.leading, 16)
            
            TextField("enter location...", text: $locationInput)
                .foregroundColor(.primary)
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 14)
                .autocapitalization(.none)
        }
        .background(accentColor.opacity(0.3))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(primaryColor.opacity(0.5), lineWidth: 1.5)
                .shadow(color: secondaryColor.opacity(0.3), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private var weatherButtonView: some View {
        Button(action: {
            if !locationInput.isEmpty {
                locationManager.geocodeLocation(query: locationInput)
            }
        }) {
            HStack {
                Text("get weather")
                    .fontWeight(.bold)
                    .font(.system(size: 17))
                
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 18))
            }
            .frame(width: 220, height: 54)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [primaryColor, secondaryColor]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(27)
            .overlay(
                RoundedRectangle(cornerRadius: 27)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
            )
            .shadow(color: primaryColor.opacity(0.5), radius: 8, x: 0, y: 4)
        }
        .disabled(locationInput.isEmpty || locationManager.isLoading)
        .opacity(locationInput.isEmpty || locationManager.isLoading ? 0.6 : 1)
        .scaleEffect(locationInput.isEmpty || locationManager.isLoading ? 0.98 : 1.0)
        .animation(.spring(response: 0.3), value: locationInput.isEmpty || locationManager.isLoading)
        .padding(.top, 8)
    }
    
    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: primaryColor))
            .scaleEffect(1.2)
            .padding()
    }
    
    private var errorView: some View {
        Text(locationManager.errorMessage)
            .foregroundColor(.red)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
    }
    
    private var favoritesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("FAVORITES")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(primaryColor)
                    .tracking(1.5)
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .foregroundColor(primaryColor)
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(locationManager.favorites) { favorite in
                        favoriteRowView(for: favorite)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 24)
    }
    
    private func favoriteRowView(for favorite: Location) -> some View {
        NavigationLink(destination: LocationDetailView(location: favorite)) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(favorite.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("Tap for details")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(secondaryColor)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(primaryColor.opacity(0.7))
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(accentColor.opacity(0.2))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(primaryColor.opacity(0.3), lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var favoriteButton: some View {
        Button(action: {
            // Show favorites screen or manage favorites
        }) {
            Image(systemName: "heart.fill")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(primaryColor)
        }
    }
}

#Preview {
    ContentView()
}
