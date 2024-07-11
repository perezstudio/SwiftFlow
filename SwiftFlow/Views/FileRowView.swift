//
//  FileRowView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/29/24.
//

import SwiftUI

struct FileRowView: View {
    var file: Files
    @Binding var selectedFile: Files?
    @Binding var editingFileID: UUID?
    @Binding var newFileName: String
    
    var body: some View {
        HStack {
            if file.type == "View" {
                Image(systemName: "swift")
                    .foregroundColor(Color.orange)
            } else if file.type == "Model" {
                Image(systemName: "tablecells")
                    .foregroundColor(Color.mint)
            } else if file.type == "Query" {
                Image(systemName: "externaldrive.connected.to.line.below")
                    .foregroundColor(Color.red)
            } else {
                Image(systemName: "square.stack")
                    .foregroundColor(Color.blue)
            }
            if editingFileID == file.id {
                TextField("File Name", text: $newFileName, onCommit: {
                    if !newFileName.isEmpty {
                        file.name = newFileName
                        try? file.modelContext?.save()
                        editingFileID = nil
                    }
                })
                .textFieldStyle(PlainTextFieldStyle())
                .frame(maxWidth: .infinity)
            } else {
                Text(file.name)
                    .foregroundColor(selectedFile?.id == file.id ? .blue : .primary) // Highlight selected file
                    .onTapGesture(count: 2) {
                        editingFileID = file.id
                        newFileName = file.name
                    }
                    .onTapGesture {
                        selectedFile = file
                    }
            }
        }
    }
}
