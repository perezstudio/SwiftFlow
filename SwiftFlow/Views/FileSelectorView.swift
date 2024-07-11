//
//  FileSelectorView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/25/24.
//

import SwiftUI
import SwiftData

struct FileSelectorView: View {
    @Binding var files: [Files]
    @Binding var selectedFile: Files?
    @State private var editingFileID: UUID?
    @State private var newFileName: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Views")) {
                    ForEach(files.filter { $0.type == "View" }) { file in
                        FileRowView(file: file, selectedFile: $selectedFile, editingFileID: $editingFileID, newFileName: $newFileName)
                    }
                }
                Section(header: Text("Models")) {
                    ForEach(files.filter { $0.type == "Model" }) { file in
                        FileRowView(file: file, selectedFile: $selectedFile, editingFileID: $editingFileID, newFileName: $newFileName)
                    }
                }
                Section(header: Text("Logic")) {
                    ForEach(files.filter { $0.type == "Logic" }) { file in
                        FileRowView(file: file, selectedFile: $selectedFile, editingFileID: $editingFileID, newFileName: $newFileName)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Files")
        }
    }
}

//#Preview {
//    FileSelectorView()
//}
