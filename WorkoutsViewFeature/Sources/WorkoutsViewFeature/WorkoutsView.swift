import SwiftUI
import WorkoutsClient

// Displays list view for workouts fetched
public struct WorkoutsView: View {
    public init(client: WorkoutsClient,
                selectedQuery: Binding<WorkoutTypeQuery>) {
        self.client = client
        self._selectedQuery = selectedQuery
    }
    
    @Binding private var selectedQuery: WorkoutTypeQuery
    let client: WorkoutsClient
    @State private var workouts = [Workout]()
    
    var typeString: String {
        "\(selectedQuery.workoutType)"
    }
    
    public var body: some View {
        List {
            ForEach(workouts) { workout in
                Text(typeString)
                Text(workout.calories)
            }
        }
        .padding()
        .onChange(of: selectedQuery, { oldValue, newValue in
            Task {
                workouts = try! await client.loadWorkoutsList(newValue.workoutType)
            }
        })
    }
}

#Preview {
    WorkoutsView(client: .authorizedToReadMock, selectedQuery: .constant(.init()))
}
