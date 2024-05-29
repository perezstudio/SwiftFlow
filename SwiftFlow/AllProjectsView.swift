//
//  AllProjectsView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 4/27/23.
//

import SwiftUI
import SwiftData

struct AllProjectsView: View {
    
	@Query var projects: [AppProject]
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State var searchText = ""
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach((0...42), id: \.self) {_ in
                    AppProjectCardView(appName: "Test App", appColor: Color.orange, appIcon: "swiftflow")
                }
            }
            .padding(24)
            .searchable(text: $searchText, prompt: "Search")
        }
    }
	
	func openProject() {
		
	}
}

struct AllProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        AllProjectsView()
    }
}
