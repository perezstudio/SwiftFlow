//
//  Sidebar.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/25/24.
//

import SwiftUI

struct Sidebar: View {
//    @Binding var project: Project
    @Binding var selectedTab: Tab?
        
    var body: some View {
        List {
//            AppInfoView(project: $project)
            CustomTabBar(selectedTab: $selectedTab)
            SidebarContainerView(selectedTab: $selectedTab)
        }
        .navigationTitle("Sidebar")
    }
}
