//
//  TopWorkoutAchievementLiveActivity.swift
//  TopWorkoutAchievement
//
//  Created by Yurii B on 8/7/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TopWorkoutAchievementAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TopWorkoutAchievementLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TopWorkoutAchievementAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TopWorkoutAchievementAttributes {
    fileprivate static var preview: TopWorkoutAchievementAttributes {
        TopWorkoutAchievementAttributes(name: "World")
    }
}

extension TopWorkoutAchievementAttributes.ContentState {
    fileprivate static var smiley: TopWorkoutAchievementAttributes.ContentState {
        TopWorkoutAchievementAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TopWorkoutAchievementAttributes.ContentState {
         TopWorkoutAchievementAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TopWorkoutAchievementAttributes.preview) {
   TopWorkoutAchievementLiveActivity()
} contentStates: {
    TopWorkoutAchievementAttributes.ContentState.smiley
    TopWorkoutAchievementAttributes.ContentState.starEyes
}
