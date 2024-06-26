//
//  TutorialModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/29/24.
//

import SwiftUI
import SwiftData

struct Tutorial: Identifiable, Codable {
	var id = UUID()
	var title: String
	var icon: String
	
	init(id: UUID = UUID(), title: String, icon: String) {
		self.id = id
		self.title = title
		self.icon = icon
	}
}
