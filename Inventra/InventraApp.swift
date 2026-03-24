//
//  InventraApp.swift
//  Inventra
//
//  Created by XCODE on 24/03/26.
//

import SwiftUI

@main
struct InventraApp: App {
    @State private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated, let user = authManager.currentUser {
                HomeView(user: user)
            } else {
                LoginView()
            }
        }
    }
}
