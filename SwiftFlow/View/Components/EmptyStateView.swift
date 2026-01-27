//
//  EmptyStateView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A view displayed when there's no content to show
struct EmptyStateView: View {
    let title: String
    let message: String?
    let systemImage: String
    let action: (() -> Void)?
    let actionTitle: String?

    init(
        _ title: String,
        message: String? = nil,
        systemImage: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)

            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if let message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            if let action, let actionTitle {
                Button(action: action) {
                    Text(actionTitle)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

/// A compact empty state for smaller areas
struct CompactEmptyState: View {
    let message: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 14))
                .foregroundStyle(.tertiary)

            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

/// An empty state specifically for lists
struct EmptyListState: View {
    let itemType: String
    let action: (() -> Void)?

    init(itemType: String, action: (() -> Void)? = nil) {
        self.itemType = itemType
        self.action = action
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("No \(itemType)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let action {
                Button(action: action) {
                    Label("Add \(itemType)", systemImage: "plus")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}

/// Loading state view
struct LoadingView: View {
    let message: String?

    init(_ message: String? = nil) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)

            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Error state view
struct ErrorView: View {
    let error: Error
    let retryAction: (() -> Void)?

    init(_ error: Error, retryAction: (() -> Void)? = nil) {
        self.error = error
        self.retryAction = retryAction
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundStyle(.orange)

            VStack(spacing: 4) {
                Text("Something went wrong")
                    .font(.headline)

                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let retryAction {
                Button("Try Again", action: retryAction)
                    .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    VStack {
        EmptyStateView(
            "No Project Selected",
            message: "Select a project from the sidebar or create a new one",
            systemImage: "folder",
            actionTitle: "Create Project"
        ) {
            print("Create project")
        }
        .frame(height: 300)
        .background(Color(nsColor: .windowBackgroundColor))

        Divider()

        CompactEmptyState(message: "No properties defined", systemImage: "list.bullet")
            .background(Color(nsColor: .controlBackgroundColor))

        Divider()

        EmptyListState(itemType: "View") {
            print("Add view")
        }
        .background(Color(nsColor: .controlBackgroundColor))

        Divider()

        LoadingView("Loading project...")
            .frame(height: 100)

        Divider()

        ErrorView(NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load data"])) {
            print("Retry")
        }
        .frame(height: 200)
    }
}
