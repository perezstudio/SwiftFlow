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
                        ZStack(alignment: .topTrailing) {
                            VStack {
                                NavigationLink(destination: ProjectEditorView(project: app)) {
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
                                }
                                .background(colorFromString(app.primaryColor).opacity(0.20))
                                .cornerRadius(10)
                                Text(app.name)
                            }
                            VStack {
                                Image(systemName: "ellipsis")
                                    .padding(8)
                                    .background(Color.white.opacity(0.20))
                                    .foregroundColor(Color.white)
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        currentProject = app
                                        isPresentingProjectForm = true
                                    }
                            }
                            .padding([.top, .trailing], 8)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        currentProject = nil
                        isPresentingProjectForm = true
                    }) {
                        Image(systemName: "plus")
                        Text("New App")
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingProjectForm) {
            AppProjectFormView(project: $currentProject)
                .onDisappear {
                    currentProject = nil
                }
        }
    }
}

#Preview {
    ContentView()
}
