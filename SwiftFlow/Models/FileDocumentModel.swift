//
//  FileDocumentModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/21/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ProjectDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }

    var project: AppProject

    init(project: AppProject = AppProject(name: "New Project", path: "", version: "1.0", primaryColor: "#FFFFFF", icon: "", macOS: true, iPadOS: true, iOS: true)) {
        self.project = project
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        self.project = try decoder.decode(AppProject.self, from: data)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let data = try encoder.encode(project)
        return FileWrapper(regularFileWithContents: data)
    }
}

struct Project: Codable, Identifiable {
    var id = UUID()
    var name: String
    var creationDate = Date()
}
