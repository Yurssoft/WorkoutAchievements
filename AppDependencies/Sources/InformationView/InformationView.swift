//
//  InformationView.swift
//
//
//  Created by Yurii B on 12/1/23.
//

import SwiftUI

extension InformationView {
    struct RecommendedApp: Identifiable {
        let appName: String
        let link: String
        let id = UUID().uuidString
    }
    
    var recommendedApps: [RecommendedApp] {
        [
            RecommendedApp(appName: "FitnessView", link: "https://apps.apple.com/us/app/fitnessview-activity-tracker/id1531983371"),
                RecommendedApp(appName: "FitMetrics", link: "https://apps.apple.com/us/app/fitmetrics-your-fitness-and-health-dashboard-track/id965643854"),
            RecommendedApp(appName: "Health Stats", link: "https://apps.apple.com/us/app/health-stats/id1543220823"),
            RecommendedApp(appName: "HealthView", link: "https://apps.apple.com/us/app/healthview/id1020452064")
        ]
    }
}

public struct InformationView: View {
    public init(closeTapped: @escaping () -> Void = { }) {
        self.closeTapped = closeTapped
    }
    
    public var closeTapped: () -> Void = { }
    
    public var body: some View {
        VStack {
            VStack {
                Image(systemName: "info")
                    .imageScale(.large)
                    .tint(.blue)
                Link("Feedback & Contact", destination: URL(string: "https://www.linkedin.com/in/yurii-boiko/")!)
                    .padding()
            }
            
            VStack {
                Text("About")
                    .font(.headline)
                Text("When using workouts on watch, like running or swimming, have you ever wondered about your best workout?\nWorkout app allows to see your best day/week/month/year of exercise. Easily find your best hike ever. See averages for selected period.")
                    .padding()
            }
            
            VStack {
                Text("Recommended Related Apps")
                    .font(.headline)
                ForEach(recommendedApps) { recommendedApp in
                    Link(recommendedApp.appName, destination: URL(string: recommendedApp.link)!)
                        .padding()
                }
            }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    closeTapped()
                } label: {
                    Image(systemName: "xmark")
                        .tint(.blue)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        InformationView()
    }
}
