//
//  SidebarContainerView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/26/24.
//

import SwiftUI

struct SidebarContainerView: View {
    @Binding var selectedTab: Tab?
    @Bindable var project: AppProject
    @Binding var selectedFile: Files?
    @Binding var draggedComponent: Component?
    
    var body: some View {
        VStack {
            if(selectedTab == .fileSelector) {
                FileSelectorView(files: $project.files, selectedFile: $selectedFile)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if (selectedTab == .fileStructure) {
                FileStructureView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if (selectedTab == .components) {
                ComponentListView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview {
//    SidebarContainerView()
//}
