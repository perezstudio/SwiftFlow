//
//  SidebarContainerView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/26/24.
//

import SwiftUI

struct SidebarContainerView: View {
    @Binding var selectedTab: Tab?
    
    var body: some View {
        if(selectedTab == .fileSelector) {
            FileSelectorView()
        } else if (selectedTab == .fileStructure) {
            FileStructureView()
        } else if (selectedTab == .components) {
            ComponentListView()
        }
    }
}

//#Preview {
//    SidebarContainerView()
//}
