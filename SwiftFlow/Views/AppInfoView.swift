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
    @Bindable var project: AppProject
    
    var body: some View {
        HStack {
            ZStack {
                Image(systemName: project.icon)
            }
            .frame(width: 40, height: 40)
            .background(colorFromString(project.primaryColor))
            .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(project.name)
                    .font(.title3)
                    .fontWeight(.bold)
                Text("App Settings")
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Material.bar)
        .cornerRadius(10)
    }
}

//#Preview {
//    AppInfoView()
//}
