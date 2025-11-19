//
//  Demo1App.swift
//  Demo1
//
//  Created by Vu Dang on 10/11/25.
//

import SwiftUI

@main
struct Demo1App: App {
    
    init() {
        RealmManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
