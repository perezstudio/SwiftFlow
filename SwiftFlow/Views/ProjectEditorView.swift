//
//  ProjectEditorView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/21/24.
//

import SwiftUI
import SwiftData

struct ProjectEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab: Tab? = .fileSelector
    @State private var createProjectModal = false
    @State private var selectedFile: Files? = nil
    @Bindable var project: AppProject
    @State var draggedComponent: Component?

    var body: some View {
        NavigationSplitView {
            Sidebar(project: project, selectedTab: $selectedTab, selectedFile: $selectedFile, draggedComponent: $draggedComponent)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Menu {
                            Button(action: {
                                createNewFile(type: "View")
                            }) {
                                Label("New View", systemImage: "rectangle.3.group")
                            }

                            Button(action: {
                                createNewFile(type: "Model")
                            }) {
                                Label("New Model", systemImage: "tablecells")
                            }

                            Button(action: {
                                createNewFile(type: "Logic")
                            }) {
                                Label("New Logic", systemImage: "externaldrive.connected.to.line.below")
                            }
                        } label: {
                            Image(systemName: "document.badge.plus")
                        }
                    }
                }
        } detail: {
            DetailView(project: project, selectedFile: $selectedFile, draggedComponent: $draggedComponent)
        }
        
    }
    
    private func createNewFile(type: String) {
        let newFileName = generateUniqueFileName(type: type)
        let newFile = Files(name: newFileName, content: "", type: type)
        project.files.append(newFile)
        try? modelContext.save()
    }
    
    private func generateUniqueFileName(type: String) -> String {
        let baseName = "New \(type)"
        var counter = 1
        var uniqueName = baseName
        
        while project.files.contains(where: { $0.name == uniqueName }) {
            counter += 1
            uniqueName = "\(baseName) \(counter)"
        }
        
        return uniqueName
    }
}
