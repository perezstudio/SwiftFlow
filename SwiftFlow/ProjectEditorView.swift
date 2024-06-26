//
//  ProjectEditorView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/21/24.
//

import SwiftUI

struct ProjectEditorView: View {
    @State private var selectedTab: Tab? = .fileSelector

    var body: some View {
        NavigationSplitView {
            Sidebar(selectedTab: $selectedTab)
        } detail: {
            DetailView()
        }
    }
}
