import SwiftUI
import WorkoutsClient

// Displays list view for workouts fetched
public struct WorkoutsView: View {
    public init() { }
    let workouts = [Workout]()
    public var body: some View {
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
    WorkoutsView()
}
