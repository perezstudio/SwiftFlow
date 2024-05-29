//
//  ViewComponentModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

@Model class ViewComponent {
	@Attribute var id: UUID = UUID()
	@Attribute var type: String
	@Attribute var properties: [String: String]
	@Relationship var children: [ViewComponent]?

	init(type: String, properties: [String: String] = [:], children: [ViewComponent]? = nil) {
		self.type = type
		self.properties = properties
		self.children = children
	}
}
