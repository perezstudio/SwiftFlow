import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationView {
			Sidebar()
			MainView()
		}
		.toolbar {
			Spacer()
			Button(action: toggleSidebar) {
				Image(systemName: "play.fill")
			}
			Button(action: toggleSidebar) {
				Image(systemName: "ellipsis.circle")
			}
			Button(action: toggleSidebar) {
				Image(systemName: "sidebar.left")
			}
		}
	}
	func toggleSidebar() {
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
	}
}

struct Sidebar: View {
	
	@State private var selectedTab: Tab = .files

	enum Tab {
		case files, navigator, symbols
	}
	
	var body: some View {
		NavigationStack {
			List {
				Section () {
					VStack(alignment: .leading) {
						Text("My App")
							.font(.title3)
							.fontWeight(.bold)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text("App Settings")
							.font(.caption)
					}
					.padding(12)
					.frame(width: .infinity, alignment: .leading)
					.background(Material.bar)
					.cornerRadius(8)
				}
				.frame(maxWidth: .infinity)
				Section() {
					Picker("", selection: $selectedTab) {
					Image(systemName: "doc").tag(Tab.files)
					Image(systemName: "filemenu.and.selection").tag(Tab.navigator)
					Image(systemName: "diamond.righthalf.filled").tag(Tab.symbols)
					}
					.pickerStyle(SegmentedPickerStyle())
					.accentColor(.blue)
				}
				switch selectedTab {
							case .files:
								List {
									Section(header: Text("\(Image(systemName: "rectangle.3.group")) Views")) {
										Label("Components", systemImage: "swift")
										Label("ContentView", systemImage: "swift")
									}
									Section(header: Text("\(Image(systemName: "tablecells")) Data")) {
										Label("ProjectsModel", systemImage: "swiftdata")
										Label("TasksModel", systemImage: "swiftdata")
										Label("ProjectsSync", systemImage: "tablecells")
										Label("TasksSync", systemImage: "tablecells")
									}
									Section(header: Text("\(Image(systemName: "externaldrive.connected.to.line.below")) Queries")) {
										Label("Query1", systemImage: "externaldrive.connected.to.line.below")
									}
								}
								.frame(height: 300)
							case .navigator:
								List {
									Label("ProjectsModel", systemImage: "tray")
									Label("TasksModel", systemImage: "tray")
									Label("ProjectsSync", systemImage: "arrow.triangle.2.circlepath")
									Label("TasksSync", systemImage: "arrow.triangle.2.circlepath")
								}
								.frame(maxHeight: .infinity)
							case .symbols:
								List {
									Label("Query1", systemImage: "magnifyingglass")
								}
								.frame(maxHeight: .infinity)
							}
			}
			.listStyle(SidebarListStyle())
			.frame(minWidth: 200, idealWidth: 250, maxWidth: .infinity)
		}
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button(action: toggleSidebar) {
					Image(systemName: "sidebar.left")
				}
			}
			ToolbarItemGroup(placement: .primaryAction) {
				Spacer()
				Button(action: toggleSidebar) {
					Image(systemName: "doc.badge.plus")
				}
				Button(action: toggleSidebar) {
					Image(systemName: "folder.badge.plus")
				}
			}
			ToolbarItem(placement: .navigation) {
				Button(action: toggleSidebar) {
					Image(systemName: "plus.app")
				}
			}
		}
		
		
	}
	
	func toggleSidebar() {
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
	}
}

struct MyAppView: View {
	var body: some View {
		Text("My World")
	}
	
	func toggleSidebar() {
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
	}
}

struct MainView: View {
	var body: some View {
		ZStack {
			HStack {
				VStack(alignment: .leading) {
					Spacer()
					Button(action: {
						print("Button tapped")
					}) {
						Image(systemName: "chevron.left.forwardslash.chevron.right")
							.foregroundColor(.blue)
							.padding()
							.background(Material.thick)
							.clipShape(Circle())
					}
					.clipShape(Circle())
					Button(action: {
						print("Button tapped")
					}) {
						Image(systemName: "sun.max")
							.foregroundColor(.blue)
							.padding()
							.background(Material.thick)
							.clipShape(Circle())
					}
					.clipShape(Circle())
					Button(action: {
						print("Button tapped")
					}) {
						Image(systemName: "ipad.and.iphone")
							.foregroundColor(.blue)
							.padding()
							.background(Material.thick)
							.clipShape(Circle())
					}
					.clipShape(Circle())
					Button(action: {
						print("Button tapped")
					}) {
						Image(systemName: "iphone")
							.foregroundColor(.blue)
							.padding()
							.background(Material.thick)
							.clipShape(Circle())
					}
					.clipShape(Circle())
					HStack(spacing: 4) {
						Button(action: {
							print("Button tapped")
						}) {
							Image(systemName: "plus.magnifyingglass")
								.foregroundColor(.blue)
								.padding()
								.background(Material.thick)
								.clipShape(Circle())
						}
						.clipShape(Circle())
						Button(action: {
							print("Button tapped")
						}) {
							Image(systemName: "minus.magnifyingglass")
								.foregroundColor(.blue)
								.padding()
								.background(Material.thick)
								.clipShape(Circle())
						}
						.clipShape(Circle())
					}
				}
				Spacer()
			}
			.padding(16)
			HStack(alignment: .center) {
				VStack {
					ZStack {
						RoundedRectangle(cornerRadius: 30)  // Main iPhone shape
							.fill(Color.gray.opacity(0.5))  // iPhone color
						RoundedRectangle(cornerRadius: 28)  // Screen simulation
							.inset(by: 10)
							.fill(Color.black)
						VStack {  // Notch simulation
							Capsule()
								.fill(Color.black)
								.frame(width: 100, height: 20)
								.padding(.top, 10)
							Spacer()
						}
					}
				}
				.frame(width: 200, height: 400)  // Adjust frame size as per your UI design
				.shadow(radius: 10)
			}
			.scaleEffect(1.5)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
