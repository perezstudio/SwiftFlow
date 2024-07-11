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
    @Binding var project: AppProject?
    
    @State private var projectName: String = ""
    @State private var projectVersion: String = ""
    @State private var projectPrimaryColor: String = ""
    @State private var projectIcon: String = "square.stack"
    @State private var projectMacOS: Bool = false
    @State private var projectiPadOS: Bool = false
    @State private var projectiOS: Bool = false
    @State private var selectedColor: ColorOption? = nil
    @State private var projectFiles: [Files]? = []
    
    private var isEditing: Bool {
        return project != nil
    }

    private var formTitle: String {
        isEditing ? "Edit Project" : "New Project"
    }
    
    private var formButton: String {
        isEditing ? "Update" : "Create"
    }

    private func save() {
        if isEditing {
            if let project = self.project {
                project.name = projectName
                project.version = projectVersion
                project.primaryColor = projectPrimaryColor
                project.icon = projectIcon
                project.macOS = projectMacOS
                project.iPadOS = projectiPadOS
                project.iOS = projectiOS
                try? modelContext.save()
            }
        } else {
            let newProject = AppProject (
                name: projectName,
                version: projectVersion,
                primaryColor: projectPrimaryColor,
                icon: projectIcon,
                macOS: projectMacOS,
                iPadOS: projectiPadOS,
                iOS: projectiOS,
                files: projectFiles ?? []
            )
            modelContext.insert(newProject)
        }
        project = nil // Reset project after saving
    }
    
    private func delete() {
        if let project = self.project {
            modelContext.delete(project)
            try? modelContext.save()
            self.project = nil
            self.presentationMode.wrappedValue.dismiss()
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $projectName)
                    TextField("Version", text: $projectVersion)
                    TextField("Icon", text: $projectIcon)
                }
                Section(header: Text("Primary Color")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                        ForEach(colorOptions) { option in
                            Button(action: {
                                selectedColor = option
                                projectPrimaryColor = option.name
                            }) {
                                Circle()
                                    .fill(selectedColor?.id == option.id ? option.color : option.color.opacity(0.30))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle()
                                            .stroke(option.color, lineWidth: 2)
                                    )
                            }
                        }
                    }
                }
                Section(header: Text("Platforms")) {
                    HStack {
                        VStack(spacing: 8) {
                            Image(systemName: "macpro.gen3.fill")
                                .font(.title)
                            Text("macOS")
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
                        .foregroundColor(projectMacOS ? Color.orange : Color.gray)
                        .background(projectMacOS ? Color.orange.opacity(0.20) : Color.gray.opacity(0.20))
                        .cornerRadius(8)
                        .onTapGesture {
                            projectMacOS.toggle()
                        }
                        VStack(spacing: 8) {
                            Image(systemName: "ipad.gen2.landscape")
                                .font(.title)
                            Text("iPadOS")
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .foregroundColor(projectiPadOS ? Color.orange : Color.gray)
                        .background(projectiPadOS ? Color.orange.opacity(0.20) : Color.gray.opacity(0.20))
                        .cornerRadius(8)
                        .onTapGesture {
                            projectiPadOS.toggle()
                        }
                        VStack(spacing: 8) {
                            Image(systemName: "iphone.gen2")
                                .font(.title)
                            Text("iOS")
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .foregroundColor(projectiOS ? Color.orange : Color.gray)
                        .background(projectiOS ? Color.orange.opacity(0.20) : Color.gray.opacity(0.20))
                        .cornerRadius(8)
                        .onTapGesture {
                            projectiOS.toggle()
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                if let project = self.project {
                    projectName = project.name
                    projectVersion = project.version
                    projectPrimaryColor = project.primaryColor
                    projectIcon = project.icon
                    projectMacOS = project.macOS
                    projectiPadOS = project.iPadOS
                    projectiOS = project.iOS
                } else {
                    projectName = ""
                    projectVersion = ""
                    projectPrimaryColor = ""
                    projectIcon = "square.stack"
                    projectMacOS = false
                    projectiPadOS = false
                    projectiOS = false
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
                if isEditing {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Delete", role: .destructive) {
                            delete()
                        }
                    }
                }
            }
        }
    }
}

extension AppProject {
    static var empty: AppProject {
        AppProject(name: "", version: "", primaryColor: "", icon: "", macOS: false, iPadOS: false, iOS: false, files: [])
    }
}
