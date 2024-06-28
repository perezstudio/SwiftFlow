//
//  SwiftFlowApp.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 4/27/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftUIAppBuilderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: AppProject.self)
//        #if os(iOS) || os (macOS)
//        DocumentGroup(editing: AppProject.self, contentType: .app) {
//            ContentView()
//        }
//        #else
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(for: AppProject.self)
//        #endif
    }
}
