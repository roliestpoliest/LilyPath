//
//  LilyPathApp.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

@main
struct LilyPathApp: App {
    @StateObject var healthManager = HealthManager()
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(healthManager)
        }
    }
}
