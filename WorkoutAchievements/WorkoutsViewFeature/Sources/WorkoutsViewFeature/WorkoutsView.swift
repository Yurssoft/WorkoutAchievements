import SwiftUI

// Displays list view for workouts fetched
struct WorkoutsView: View {
    let workouts = []
    var body: some View {
        List()
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
