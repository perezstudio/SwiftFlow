//
//  AppDataModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

@Model class AppData {
	@Attribute var id: UUID = UUID()
	@Attribute var key: String
	@Attribute var value: String  // Consider using a more complex structure or serialization if needed

	init(key: String, value: String) {
		self.key = key
		self.value = value
	}
}
