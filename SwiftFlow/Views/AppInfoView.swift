//
//  AppInfoView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/26/24.
//

import SwiftUI
import SwiftData

struct AppInfoView: View {
    @Environment(\.modelContext) private var context
    @Binding var project: Project
    
    var body: some View {
        VStack {
            Text(project.name)
            Text("App Settings")
        }
        
    }
}

//#Preview {
//    AppInfoView()
//}
