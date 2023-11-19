import SwiftUI
import WorkoutsClient
import FeatureFlags

extension WorkoutsView {
    enum ViewState {
        case initial
        case loading
        case error
        case list(displayValues: [DisplayStringContainer],
                  totalHours: StatisticDispayValues,
                  totalCalories: StatisticDispayValues,
                  mostEfficientWorkout: WorkoutEfficiency?)
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
    @State private var highlightedWorkoutID: String?
    
    public var body: some View {
        Group {
            switch state {
            case .initial:
                Text("Initialized🌈😏")
                
            case .loading:
                Text("Loading..........")
                
            case .error:
                Text("Error")
                
            case let .list(displayValues, totalHours, totalCalories, mostEfficientWorkout):
                listView(displayValues: displayValues,
                         totalHours: totalHours,
                         totalCalories: totalCalories,
                         mostEfficientWorkout: mostEfficientWorkout)
            }
        }
        .scrollPosition(id: $highlightedWorkoutID, anchor: .center)
        .onAppear() {
            requestData(query: selectedQuery)
        }
        .onChange(of: selectedQuery, { oldValue, newValue in
            requestData(query: newValue)
        })
    }
}

private extension WorkoutsView {
    @ViewBuilder
    func listView(displayValues: [DisplayStringContainer],
                  totalHours: StatisticDispayValues,
                  totalCalories: StatisticDispayValues,
                  mostEfficientWorkout: WorkoutEfficiency?) -> some View {
        
        VStack {
            Text("Workouts: \(displayValues.count)")
            Text("Data Period: \(totalHours.startDate) - \(totalHours.endDate)")
            Text("\(totalHours.value) Total Exercise Hours")
            Text("\(totalHours.interval) days Exercise Interval")
            Text("\(totalCalories.value) Total Exercise Calories")
            if let mostEfficientWorkout, FeatureFlags.isDisplayingWorkoutEfficency {
                Button("Most efficent workout calorie burn per minute: \(mostEfficientWorkout.calorieBurnedPerMinuteEfficiencyOfWorkoutDisplayValue)") {
                    highlightedWorkoutID = mostEfficientWorkout.workoutId
                }
            }
            Divider()
            // List is not used here as it does not work at all with scroll view
            LazyVStack {
                ForEach(displayValues) { displayValue in
                    workoutView(displayValue: displayValue)
                        .id(displayValue.workoutId)
                }
            }
            .scrollTargetLayout()
        }
    }
    
    @ViewBuilder
    func workoutView(displayValue: DisplayStringContainer) -> some View {
        VStack {
            HStack {
                Text(displayValue.displayString)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(7)
                Spacer()
            }
            .background(.gray.opacity(0.11))
            .background(displayValue.workoutId == highlightedWorkoutID ? .green : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            
            Divider()
                .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
        }
    }
}

private extension WorkoutsView {
    func requestData(query: WorkoutTypeQuery) {
        Task {
            state = .loading
            do {
                let workoutsAndStatisticsData = try await client.loadWorkoutsAndStatisticsData(query)
                let workoutsDisplayValues = workoutsAndStatisticsData.workouts.convertToDisplayContainers()
                let totalHours = workoutsAndStatisticsData.timeStatistic.displayTimeValues
                let calories = workoutsAndStatisticsData.activeEnergyBurnedStatistic.displayCaloriesValues
                state = .list(displayValues: workoutsDisplayValues.displayContainers,
                              totalHours: totalHours,
                              totalCalories: calories,
                              mostEfficientWorkout: workoutsDisplayValues.mostEfficentWorkout)
            } catch let error {
                print(Self.self, ": ", error)
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
