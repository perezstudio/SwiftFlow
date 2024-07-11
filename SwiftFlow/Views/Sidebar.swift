//
//  Sidebar.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/25/24.
//

import SwiftUI

struct Sidebar: View {
    @Bindable var project: AppProject
    @Binding var selectedTab: Tab?
    @Binding var selectedFile: Files?
    @Binding var draggedComponent: Component?
        
    var body: some View {
        VStack {
            AppInfoView(project: project)
            CustomTabBar(selectedTab: $selectedTab)
            SidebarContainerView(selectedTab: $selectedTab, project: project, selectedFile: $selectedFile, draggedComponent: $draggedComponent)
            Spacer()
        }
        .padding(16)
        .navigationTitle("Sidebar")
    }
}
