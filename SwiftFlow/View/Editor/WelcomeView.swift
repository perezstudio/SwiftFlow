//
//  WelcomeView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Welcome view shown when no file is selected
struct WelcomeView: View {
    @Environment(AppStore.self) private var appStore

    var body: some View {
        VStack(spacing: 24) {
            // App icon/logo area
            Image(systemName: "rectangle.3.group")
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)

            // Title
            Text("Welcome to SwiftFlow")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundStyle(.primary)

            // Subtitle
            Text("Select a file from the sidebar to begin editing,\nor create a new file to get started.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 400)

            // Quick actions
            VStack(spacing: 12) {
                quickActionButton(
                    title: "New View",
                    subtitle: "Create a SwiftUI view",
                    systemImage: "rectangle.on.rectangle",
                    color: .blue
                ) {
                    // Will trigger new view creation
                }

                quickActionButton(
                    title: "New Data Model",
                    subtitle: "Define a SwiftData model",
                    systemImage: "tablecells",
                    color: .green
                ) {
                    // Will trigger new model creation
                }

                quickActionButton(
                    title: "New Query",
                    subtitle: "Create an Observable query",
                    systemImage: "function",
                    color: .orange
                ) {
                    // Will trigger new query creation
                }
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    @ViewBuilder
    private func quickActionButton(
        title: String,
        subtitle: String,
        systemImage: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 280)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    WelcomeView()
        .environment(AppStore())
        .frame(width: 600, height: 500)
}
