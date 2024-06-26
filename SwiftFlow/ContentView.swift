import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var app: [AppProject]

    var body: some View {
        ProjectEditorView()
    }
}
