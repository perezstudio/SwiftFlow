//
//  StartingView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Initial view shown when the app launches - displays welcome and project list
struct StartingView: View {
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Project.modifiedAt, order: .reverse) private var projects: [Project]

    @State private var showingCreateProjectSheet = false

    var body: some View {
        HStack(spacing: 0) {
            // Left side - Welcome section
            welcomeSection
                .frame(minWidth: 350, maxWidth: 450)

            Divider()

            // Right side - Project list
            projectListSection
                .frame(minWidth: 300)
        }
        .frame(minWidth: 700, minHeight: 450)
        .ignoresSafeArea()
        .background(Color(nsColor: .windowBackgroundColor))
        .sheet(isPresented: $showingCreateProjectSheet) {
            CreateProjectSheet { project in
                openProject(project)
            }
        }
    }

    // MARK: - Welcome Section

    private var welcomeSection: some View {
        VStack(spacing: 32) {
            Spacer()

            // App icon/logo
            Image(systemName: "rectangle.3.group")
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)

            // Title
            VStack(spacing: 8) {
                Text("Welcome to SwiftFlow")
                    .font(.largeTitle)
                    .fontWeight(.medium)

                Text("Create visual Swift apps without writing code")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            // Create project button
            Button(action: { showingCreateProjectSheet = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.square")
                        .font(.system(size: 20))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Create New Project")
                            .font(.system(size: 14, weight: .medium))

                        Text("Start building your app")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .frame(width: 280)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)

            Spacer()

            // Version info
            Text("Version 1.0")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.3))
    }

    // MARK: - Project List Section

    private var projectListSection: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Recent Projects")
                    .font(.headline)

                Spacer()

                Text("\(projects.count)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color(nsColor: .separatorColor).opacity(0.5)))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider()

            // Project list
            if projects.isEmpty {
                emptyProjectsState
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(projects) { project in
                            ProjectRowView(project: project) {
                                openProject(project)
                            }

                            if project.id != projects.last?.id {
                                Divider()
                                    .padding(.leading, 60)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }

    private var emptyProjectsState: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "folder")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)

            Text("No Projects Yet")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Create a new project to get started")
                .font(.subheadline)
                .foregroundStyle(.tertiary)

            Button("Create Project") {
                showingCreateProjectSheet = true
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Actions

    private func openProject(_ project: Project) {
        appStore.setCurrentProject(project)
    }
}

// MARK: - Project Row View

private struct ProjectRowView: View {
    let project: Project
    let onSelect: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Project icon
                Image(systemName: "folder.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.1))
                    )

                // Project info
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.primary)

                    HStack(spacing: 12) {
                        Label("\(project.sortedViewFiles.count) views", systemImage: "rectangle.on.rectangle")
                        Label("\(project.sortedDataModels.count) models", systemImage: "tablecells")
                    }
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                }

                Spacer()

                // Modified date
                VStack(alignment: .trailing, spacing: 2) {
                    Text(project.modifiedAt, style: .date)
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)

                    Text(project.modifiedAt, style: .time)
                        .font(.system(size: 10))
                        .foregroundStyle(.quaternary)
                }

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.tertiary)
                    .opacity(isHovering ? 1 : 0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(isHovering ? Color(nsColor: .controlBackgroundColor) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

#Preview {
    StartingView()
        .environment(AppStore())
        .frame(width: 800, height: 500)
}
