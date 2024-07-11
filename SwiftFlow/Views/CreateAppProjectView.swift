//
//  CreateAppProjectView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/27/24.
//

import SwiftUI

struct CreateAppProjectView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @State private var projectName: String = ""
    @State private var projectDescription: String = ""
    @State private var projectVersion: String = ""
    @State private var projectPrimaryColor: String = ""
    @State private var projectIcon: String = ""
    @State private var projectMacOS: Bool = false
    @State private var projectiPadOS: Bool = false
    @State private var projectiOS: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Project Name", text: $projectName)
                    .padding()
                TextField("Project Description", text: $projectDescription)
                    .padding()
                Button("Create Project") {
                    createProject()
                }
                .padding()
                .navigationTitle("Create App Project")
                .navigationBarBackButtonHidden(false)
                
            }
        }
    }
    
    private func createProject() {
        let newProject = AppProject(name: projectName, version: projectVersion, primaryColor: projectPrimaryColor, icon: projectIcon, macOS: projectMacOS, iPadOS: projectiPadOS, iOS: projectiOS, files: []
            /*name: projectName, description: projectDescription*/)
        modelContext.insert(newProject)
        isPresented = false // Close the modal
    }
}
