import SwiftUI
import WorkoutsClient

extension WorkoutsView {
    enum ViewState {
        case initial
        case loading
        case error
        case list(workouts: [Workout])
    }
}

public struct WorkoutsView: View {
    public init(client: WorkoutsClient,
                selectedQuery: Binding<WorkoutTypeQuery>) {
        self.client = client
        self._selectedQuery = selectedQuery
    }
    
    @Binding private var selectedQuery: WorkoutTypeQuery
    let client: WorkoutsClient
    @State private var state = ViewState.initial
    
    var typeString: String {
        "\(selectedQuery.workoutType)"
    }
    
    public var body: some View {
        Group {
            switch state {
            case .initial:
                EmptyView()
                
            case .loading:
                Text("Loading..........")
                
            case .error:
                Text("Error")
                
            case .list(let workouts):
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
            state = .loading
            do {
                let workouts = try await client.loadWorkoutsList(query)
                state = .list(workouts: workouts)
            } catch {
                state = .error
            }
        }
    }
    
    func displayText(workout: Workout) -> String {
        let display = WorkoutDisplayProcessor.process(workout: workout)
        return "Calories: \(display.largeCalories) Cal \nDistance: \(display.distance) m\nTime: \(display.duration) minutes\nStarted: \(display.startDate)"
    }
}

#Preview {
    WorkoutsView(client: .workoutsMock, selectedQuery: .constant(.init()))
}
