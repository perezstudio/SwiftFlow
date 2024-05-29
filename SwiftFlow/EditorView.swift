//
//  EditorView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 1/6/24.
//

import SwiftUI

struct EditorView: View {
	
	@Binding var showAlternateView: Bool
	
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
	EditorView(showAlternateView: .constant(false))
}
