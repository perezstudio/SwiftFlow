//
//  EmptyInspectorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Empty state view for the inspector when nothing is selected
struct EmptyInspectorView: View {
    let message: String
    var systemImage: String = "sidebar.right"

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 32))
                .foregroundStyle(.tertiary)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Select an item to view its properties")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    VStack {
        EmptyInspectorView(message: "No Selection")
        Divider()
        EmptyInspectorView(message: "Block not found", systemImage: "exclamationmark.triangle")
    }
    .frame(width: 280, height: 400)
}
