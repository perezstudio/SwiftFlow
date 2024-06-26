//
//  Sidebar.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/25/24.
//

import SwiftUI

struct Sidebar: View {
    
    @Binding var selectedTab: Tab?
        
    var body: some View {
        
        List {
            CustomTabBar(selectedTab: $selectedTab)
        }
        .navigationTitle("Sidebar")
    }
}
