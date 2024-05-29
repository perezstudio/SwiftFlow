//
//  AppSettingsModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

@Model class AppSettings: Identifiable {
	var id: UUID = UUID()
	var theme: String
	var language: String

	init(theme: String, language: String) {
		self.theme = theme
		self.language = language
	}
}
