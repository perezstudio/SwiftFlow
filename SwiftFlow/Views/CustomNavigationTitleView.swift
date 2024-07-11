//
//  CustomNavigationTitleView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/30/24.
//

import SwiftUI

struct CustomNavigationTitleView: View {
    @Binding var title: String
    @Binding var subtitle: String
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

