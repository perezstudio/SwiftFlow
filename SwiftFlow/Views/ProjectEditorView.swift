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
    @Query var projects: [AppProject]
    @State var project: AppProject

    var body: some View {
        if let project = projects.first, projects.count == 1 {
//            NavigationSplitView {
//                Sidebar(project: project, selectedTab: $selectedTab)
//                    .toolbar {
//                        ToolbarItem(placement: .automatic) {
//                            Menu {
//                                Button(action: {
//                                    // Action for New View
//                                    print("New View selected")
//                                }) {
//                                    Label("New View", systemImage: "rectangle.3.group")
//                                }
//
//                                Button(action: {
//                                    // Action for New Model
//                                    print("New Model selected")
//                                }) {
//                                    Label("New Model", systemImage: "tablecells")
//                                }
//
//                                Button(action: {
//                                    // Action for New Query
//                                    print("New Query selected")
//                                }) {
//                                    Label("New Query", systemImage: "externaldrive.connected.to.line.below")
//                                }
//                            } label: {
//                                Image(systemName: "plus")
//                            }
//                        }
//                    }
//            } detail: {
//                DetailView()
//            }
        } else {
            NavigationSplitView {
                Sidebar(selectedTab: $selectedTab)
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            Menu {
                                Button(action: {
                                    // Action for New View
                                    print("New View selected")
                                }) {
                                    Label("New View", systemImage: "rectangle.3.group")
                                }

                                Button(action: {
                                    // Action for New Model
                                    print("New Model selected")
                                }) {
                                    Label("New Model", systemImage: "tablecells")
                                }

                                Button(action: {
                                    // Action for New Query
                                    print("New Query selected")
                                }) {
                                    Label("New Query", systemImage: "externaldrive.connected.to.line.below")
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
            } detail: {
                DetailView()
            }
            .sheet(isPresented: $createProjectModal) {
                CreateAppProjectView(isPresented: $createProjectModal)
                    }
        }
        
    }
}
