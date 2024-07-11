//
//  ComponentListView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/25/24.
//

import SwiftUI

struct ComponentListView: View {
    
    var body: some View {
        List {
            ForEach(ComponentType.allCases, id: \.self) { componentType in
                HStack {
                    componentType.icon
                    Text(componentType.displayName)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .listStyle(.sidebar)
    }
}

//#Preview {
//    ComponentListView()
//}
