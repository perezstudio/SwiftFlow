//
//  FileNavigatorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Context-sensitive navigator that shows content based on selected file type
struct FileNavigatorView: View {
    @Environment(AppStore.self) private var appStore

    var body: some View {
        Group {
            if let fileType = appStore.selectedFileType {
                switch fileType {
                case .view:
                    ViewNavigatorView()
                case .dataModel:
                    ModelNavigatorView()
                case .query:
                    QueryNavigatorView()
                }
            } else {
                noSelectionView
            }
        }
    }

    private var noSelectionView: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 32))
                .foregroundStyle(.tertiary)

            Text("No File Selected")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Select a file from the Files tab to see its structure")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    FileNavigatorView()
        .environment(AppStore())
        .frame(width: 250, height: 400)
}
