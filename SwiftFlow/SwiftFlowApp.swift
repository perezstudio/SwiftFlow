//
//  SwiftFlowApp.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 4/27/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftFlowApp: App {
	
	let modelContainer: ModelContainer

	init() {
		do {
			modelContainer = try ModelContainer(for: AppProject.self)
		} catch {
			fatalError("Could not initialize ModelContainer")
		}
	}


	
    var body: some Scene {
		WindowGroup {
			StartupPopupView()
				.accentColor(.blue)
		}
		.modelContainer(modelContainer)
    }
}
