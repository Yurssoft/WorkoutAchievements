import SwiftUI
import WorkoutsClient

extension WorkoutsView {
    enum ViewState {
        case initial
        case loading
        case error
        case list(displayValues: [DisplayStringContainer])
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
    
    public var body: some View {
        Group {
            switch state {
            case .initial:
                Text("Initialized🌈😏")
                
            case .loading:
                Text("Loading..........")
                
            case .error:
                Text("Error")
                
            case .list(let displayValues):
                VStack {
                    Text("List total entries: \(displayValues.count)")
                    List {
                        ForEach(displayValues) { displayValue in
                            Text(displayValue.displayString)
                        }
                    }
                }
            }
        }
        .onAppear() {
            requestData(query: selectedQuery)
        }
        .onChange(of: selectedQuery, { oldValue, newValue in
            requestData(query: newValue)
        })
    }
    
}

private extension WorkoutsView {
    func requestData(query: WorkoutTypeQuery) {
        Task {
            state = .loading
            do {
                let workouts = try await client.loadWorkoutsList(query)
                let displayValues = workouts.map { $0.displayValues }.map { $0.displayContainer }
                state = .list(displayValues: displayValues)
            } catch {
                state = .error
            }
        }
    }
}

#Preview {
    WorkoutsView(client: .workoutsMock, selectedQuery: .constant(.init()))
}
