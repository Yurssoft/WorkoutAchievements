import SwiftUI
import WorkoutsClient

// Displays list view for workouts fetched
public struct WorkoutsView: View {
    public init(client: WorkoutsClient) {
        self.client = client
    }
    let client: WorkoutsClient
    @State private var workouts = [Workout]()
    public var body: some View {
        List {
            ForEach(workouts) { workout in
                Text(workout.calories)
            }
        }
        .padding()
        .task {
            workouts = await client.loadWorkoutsList(.swimming)
        }
    }
}

#Preview {
    WorkoutsView(client: .authorizedToReadMock)
}
