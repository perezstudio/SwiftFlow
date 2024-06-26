//
//  TabBarButton.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/25/24.
//

import SwiftUI

struct TabBarButton: View {
    let icon: String
    let tab: Tab?
    @Binding var selectedTab: Tab?
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.primary)
                .padding(.vertical, 4)
                .background(selectedTab == tab ? Color.orange.opacity(0.80) : Color.clear)
                .font(.caption)
                .cornerRadius(6)
        }
        .onTapGesture {
            selectedTab = tab ?? .fileSelector
        }
        
    }
}
