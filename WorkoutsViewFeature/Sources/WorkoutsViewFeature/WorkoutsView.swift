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
                        Text(displayText(workout: workout))
                    }
                }
            }
        }
        .onChange(of: selectedQuery, { oldValue, newValue in
            requestData(query: newValue)
        })
        .onAppear() {
            requestData(query: selectedQuery)
        }
    }
    
}

private extension WorkoutsView {
    func requestData(query: WorkoutTypeQuery) {
        Task {
            isLoading = true
            workouts = try! await client.loadWorkoutsList(query)
            isLoading = false
        }
    }
    
    func displayText(workout: Workout) -> String {
        let display = WorkoutDisplayProcessor.process(workout: workout)
        return "Calories: \(display.largeCalories) Cal \nDistance: \(display.distance) m\nTime: \(display.duration) minutes\nStarted: \(display.startDate)"
    }
}

#Preview {
    WorkoutsView(client: .authorizedToReadMock, selectedQuery: .constant(.init()))
}
