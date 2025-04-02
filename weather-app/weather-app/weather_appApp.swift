//
//  weather_appApp.swift
//  weather-app
//
//  Created by Michelle Chang on 3/27/25.
//

import SwiftUI

@main
struct weather_appApp: App {
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
        }
    }
}
