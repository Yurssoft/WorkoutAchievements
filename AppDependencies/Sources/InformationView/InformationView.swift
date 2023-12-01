//
//  InformationView.swift
//
//
//  Created by Yurii B on 12/1/23.
//

import SwiftUI

public struct InformationView: View {
    public init() { }
    
    public var body: some View {
        VStack {
            Image(systemName: "info")
                .imageScale(.large)
                .tint(.blue)
            Text("Contact")
        }
    }
}

#Preview {
    InformationView()
}
