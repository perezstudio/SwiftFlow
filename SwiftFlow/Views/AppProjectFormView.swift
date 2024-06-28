//
//  AppProjectFormView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/28/24.
//

import SwiftUI
import SwiftData

struct AppProjectFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    var project: AppProject?
    @State private var projectID = UUID()
    @State var projectName: String = ""
    @State var projectVersion: String = ""
    @State var projectPrimaryColor: String = ""
    @State var projectIcon: String = "square.stack"
    @State var projectMacOS: Bool = false
    @State var projectiPadOS: Bool = false
    @State var projectiOS: Bool = false
    private var formTitle: String {
        project == nil ? "New Project" : "Edit Project"
    }
    private var formButton: String {
        project == nil ? "Create" : "Update"
    }
    
    private func save() {
        if let project = self.project {
            project.name = projectName
            project.version = projectVersion
            project.primaryColor = projectPrimaryColor
            project.icon = projectIcon
            project.macOS = projectMacOS
            project.iPadOS = projectiPadOS
            project.iOS = projectiOS
            try? modelContext.save()
        } else {
            let newProject = AppProject (
                name: projectName,
                version: projectVersion,
                primaryColor: projectPrimaryColor,
                icon: projectIcon,
                macOS: projectMacOS,
                iPadOS: projectiPadOS,
                iOS: projectiOS
            )
            modelContext.insert(newProject)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Name", text: $projectName)
                    TextField("Version", text: $projectVersion)
                    TextField("Primary Color", text: $projectPrimaryColor)
                    TextField("Icon", text: $projectIcon)
                    Toggle("macOS", isOn: $projectMacOS)
                    Toggle("iPadOS", isOn: $projectiPadOS)
                    Toggle("iOS", isOn: $projectiOS)
                }
            }
            .onAppear {
                if let project = self.project {
                    projectName = project.name
                    projectVersion = project.version
                    projectPrimaryColor = project.primaryColor
                    projectIcon = project.icon
                    projectMacOS = project.macOS
                    projectiPadOS = project.iPadOS
                    projectiOS = project.iOS
                }
            }
            .navigationTitle(formTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(formButton) {
                        save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

extension AppProject {
    static var empty: AppProject {
        AppProject(name: "", version: "", primaryColor: "", icon: "", macOS: false, iPadOS: false, iOS: false)
    }
}

//#Preview {
//    AppProjectFormView(isPresented: true)
//}
