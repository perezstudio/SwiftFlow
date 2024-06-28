import Foundation
import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var apps: [AppProject]
    @State private var isPresentingProjectForm = false
    @State private var currentProject: AppProject? = nil
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(apps) { app in
                        VStack {
                            ZStack {
                                Image(systemName: app.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .frame(width: 80, height: 80)
                                    .background(colorFromString(app.primaryColor))
                                    .cornerRadius(18)
                                    .shadow(radius: 6)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity, maxHeight: 130)
                            .background(colorFromString(app.primaryColor).opacity(0.20))
                            .cornerRadius(12)
                            Text(app.name)
                        }
                        .onTapGesture {
                            currentProject = app
                            isPresentingProjectForm = true
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        currentProject = AppProject.empty
                        isPresentingProjectForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingProjectForm) {
            if (currentProject != nil) {
                AppProjectFormView(project: currentProject)
            } else {
                AppProjectFormView()
            }
        }
    }
    
    func colorFromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
            case "blue":
                return Color.blue
            case "brown":
                return Color.brown
            case "purple":
                return Color.purple
            case "red":
                return Color.red
            case "yellow":
                return Color.yellow
            case "green":
                return Color.green
            case "teal":
                return Color.teal
            case "cyan":
                return Color.cyan
            case "gray":
                return Color.gray
            case "indigo":
                return Color.indigo
            case "mint":
                return Color.mint
            case "orange":
                return Color.orange
            case "pink":
                return Color.pink
            default:
                return Color.clear
        }
    }
    
}
