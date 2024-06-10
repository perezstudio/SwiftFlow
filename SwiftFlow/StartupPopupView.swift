//
//  StartupPopupView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

struct StartupPopupView: View {
	@Query var projects: [AppProject]
	
	let sampleTutorials = [
		Tutorial(title: "Get Started with Code", icon: "lightbulb"),
		Tutorial(title: "Get Started with Apps", icon: "apps.iphone"),
		Tutorial(title: "Organizing with Grids", icon: "square.grid.2x2"),
		Tutorial(title: "Editing Grids", icon: "square.and.pencil"),
		Tutorial(title: "Choose Your Own Story", icon: "book"),
		Tutorial(title: "Date Planner", icon: "calendar"),
		Tutorial(title: "Recognizing Gestures", icon: "hand.raised")
	]

	var body: some View {
		VStack {
			HStack {
				Text("Playgrounds")
					.font(.largeTitle)
					.fontWeight(.bold)
				Spacer()
			}
			.padding(.top, 20)
			.padding(.horizontal)

			ScrollView {
				VStack(alignment: .leading) {
					Text("My Playgrounds")
						.font(.headline)
						.padding(.horizontal)
						.padding(.top, 10)

					LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 20)], spacing: 20) {
						ForEach(projects) { project in
							VStack {
								Image(systemName: project.icon)
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(height: 60)
									.padding()
									.background(Color.gray.opacity(0.2))
									.cornerRadius(10)
								Text(project.name)
									.font(.caption)
									.foregroundColor(.primary)
									.padding(.top, 5)
							}
							.background(Color.white)
							.cornerRadius(10)
							.shadow(radius: 5)
						}
					}
					.padding(.horizontal)

					Text("More Playgrounds")
						.font(.headline)
						.padding(.horizontal)
						.padding(.top, 20)

					ScrollView(.horizontal, showsIndicators: false) {
						HStack(spacing: 20) {
							ForEach(sampleTutorials) { tutorial in
								VStack {
									Image(systemName: tutorial.icon)
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(width: 50, height: 50)
										.padding()
										.background(Color.gray.opacity(0.2))
										.cornerRadius(10)
									Text(tutorial.title)
										.font(.caption)
										.foregroundColor(.primary)
										.padding(.top, 5)
										.multilineTextAlignment(.center)
								}
								.frame(width: 100)
								.background(Color.white)
								.cornerRadius(10)
								.shadow(radius: 5)
							}
						}
						.padding(.horizontal)
					}
					.padding(.bottom, 20)
				}
			}
		}
		.background(Material.regular)
		.edgesIgnoringSafeArea(.all)
		.toolbar {
			
		}
	}
}

struct StartupPopupView_Previews: PreviewProvider {
	static var previews: some View {
		let sampleSettings = AppSettings(theme: "Light", language: "English")
		let samples: [AppProject] = [
			AppProject(name: "SwiftFlow", path: "~/Sites/SwiftFlow", version: "1.0", primaryColor: "#FFFFFF", icon: "swift", macOS: true, iPadOS: true, iOS: true, settings: sampleSettings),
			AppProject(name: "Tasks", path: "~/Sites/Foundation Task", version: "1.1", primaryColor: "#000000", icon: "tasks", macOS: true, iPadOS: true, iOS: true, settings: sampleSettings),
			AppProject(name: "foundation-api", path: "~/Sites/Foundation Task/API", version: "1.2", primaryColor: "#FF5733", icon: "api", macOS: true, iPadOS: true, iOS: true, settings: sampleSettings)
		]
		
		let sampleTutorials = [
			Tutorial(title: "Get Started with Code", icon: "lightbulb"),
			Tutorial(title: "Get Started with Apps", icon: "apps.iphone"),
			Tutorial(title: "Organizing with Grids", icon: "square.grid.2x2"),
			Tutorial(title: "Editing Grids", icon: "square.and.pencil"),
			Tutorial(title: "Choose Your Own Story", icon: "book"),
			Tutorial(title: "Date Planner", icon: "calendar"),
			Tutorial(title: "Recognizing Gestures", icon: "hand.raised")
		]

		return StartupPopupView()
	}
}
