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
    @State private var isLoading = true
    
    var typeString: String {
        "\(selectedQuery.workoutType)"
    }
    
    public var body: some View {
        Group {
            if isLoading {
                Text("Loading..........")
            } else {
                List {
                    ForEach(workouts) { workout in
                        Text(workout.calories)
                    }
                }
            }
        }
        .padding()
        .onChange(of: selectedQuery, { oldValue, newValue in
            requestData(workoutType: newValue.workoutType)
        })
        .onAppear() {
            requestData(workoutType: selectedQuery.workoutType)
        }
    }
    
    private func requestData(workoutType: WorkoutsClient.WorkoutType) {
            Task {
                isLoading = true
                workouts = try! await client.loadWorkoutsList(workoutType)
                isLoading = false
            }
    }
}

#Preview {
    WorkoutsView(client: .authorizedToReadMock, selectedQuery: .constant(.init()))
}
