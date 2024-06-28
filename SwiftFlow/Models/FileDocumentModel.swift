//
//  FileDocumentModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/21/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ProjectDocument {
    static var readableContentTypes: [UTType] { [.json] }

    var project: AppProject

    init(project: AppProject = AppProject(name: "New Project", version: "1.0", primaryColor: "#FFFFFF", icon: "", macOS: true, iPadOS: true, iOS: true)) {
        self.project = project
    }
}

struct Project: Codable, Identifiable {
    var id = UUID()
    var name: String
    var creationDate = Date()
}
