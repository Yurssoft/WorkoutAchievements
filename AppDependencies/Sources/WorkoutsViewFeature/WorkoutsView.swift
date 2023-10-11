import SwiftUI
import WorkoutsClient

extension WorkoutsView {
    enum ViewState {
        case initial
        case loading
        case error
        case list(displayValues: [DisplayStringContainer],
                  totalHours: StatisticDispayValues,
                  totalCalories: StatisticDispayValues)
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
                
            case let .list(displayValues, totalHours, totalCalories):
                VStack {
                    Text("Workouts: \(displayValues.count)")
                    Text("Data Period: \(totalHours.startDate) - \(totalHours.endDate)")
                    Text("\(totalHours.value) Total Exercise Hours")
                    Text("\(totalHours.interval) days Exercise Interval")
                    Text("\(totalCalories.value) Total Exercise Calories")
                    Divider()
                    // List is not used here as it does not work at all with scroll view
                    ForEach(displayValues) { displayValue in
                        VStack {
                            Text(displayValue.displayString)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(5)
                                .background(.gray.opacity(0.11))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            Divider()
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
                let workoutsAndStatisticsData = try await client.loadWorkoutsAndStatisticsData(query)
                let workoutsDisplayValues = workoutsAndStatisticsData.workouts
                    .map { $0.displayValues }
                    .map { $0.displayContainer }
                let totalHours = workoutsAndStatisticsData.timeStatistic.displayTimeValues
                let calories = workoutsAndStatisticsData.activeEnergyBurnedStatistic.displayCaloriesValues
                state = .list(displayValues: workoutsDisplayValues,
                              totalHours: totalHours,
                              totalCalories: calories)
            } catch {
                state = .error
            }
        }
    }
}

#Preview {
    WorkoutsView(client: .workoutsMock, selectedQuery: .constant(.init()))
        .padding()
        .padding()
}
