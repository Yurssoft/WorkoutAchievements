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
            Image(systemName: "info")
                .imageScale(.large)
                .tint(.blue)
            Link("Feedback & Contact", destination: URL(string: "https://www.linkedin.com/in/yurii-boiko/")!)
                .padding()
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
