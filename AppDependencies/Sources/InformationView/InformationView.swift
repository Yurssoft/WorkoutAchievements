//
//  InformationView.swift
//
//
//  Created by Yurii B on 12/1/23.
//

import SwiftUI

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
