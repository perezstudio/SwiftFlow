//
//  CustomTabBar.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/25/24.
//
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab?
    
    var body: some View {
        HStack(spacing: 4) {
            TabBarButton(icon: "document", tab: .fileSelector, selectedTab: $selectedTab)
            Divider()
                .frame(height: 15)
            TabBarButton(icon: "filemenu.and.selection", tab: .fileStructure, selectedTab: $selectedTab)
            Divider()
                .frame(height: 15)
            TabBarButton(icon: "diamond.lefthalf.filled", tab: .components, selectedTab: $selectedTab)
            Divider()
                .frame(height: 15)
            TabBarButton(icon: "magnifyingglass", tab: .components, selectedTab: $selectedTab)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Material.bar)
        .cornerRadius(8)
    }
}

enum Tab {
    case fileSelector
    case fileStructure
    case components
}
