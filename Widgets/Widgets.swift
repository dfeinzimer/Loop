//
//  Widgets.swift
//  Widgets
//
//  Created by David Feinzimer on 10/20/22.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> GlucoseEntry {
        GlucoseEntry(date: Date(),
                           mgCaffeine: 250.0,
                           totalCups: 2.0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (GlucoseEntry) -> Void) {
        
        if context.isPreview {
            // Show a complication with generic data.
            let entry = GlucoseEntry(date: Date(),
                        mgCaffeine: 250.0,
                        totalCups: 2.0)
            
            completion(entry)
            return
        }
        
        Task {
            
            let date = Date()
            
            // Get the current data from the model.
            let mgCaffeine = 50.0
            let totalCups = 0.5
            
            // Create the entry.
            let entry = GlucoseEntry(date: date,
                                    mgCaffeine: mgCaffeine,
                                    totalCups: totalCups)
            
            // Pass the entry to the completion handler.
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {

            // Create an array to hold the events.
            var entries: [GlucoseEntry] = []
            
            // The total number of cups consumed only changes when the user actively adds a drink,
            // so it remains constant in this timeline.
            let totalCups = 0.5

            // Generate a timeline covering every 5 minutes for the next 24 hours.
            let currentDate = Date()
            for minuteOffset in stride(from: 0, to: 60 * 24, by: 5) {
                let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                
                // Get the projected data for the specified date.
                let mgCaffeine = 100.0
                
                // Create the entry.
                let entry = GlucoseEntry(
                    date: entryDate,
                    mgCaffeine: mgCaffeine,
                    totalCups: totalCups
                )
                
                // Add the event to the array.
                entries.append(entry)
            }
            
            // Create the timeline and pass it to the completion handler.
            // Because the caffeine dose drops to 0.0 mg after 24 hours,
            // there's no need to reload this timeline unless the user adds
            // a new drink. Setting the reload policy to .never.
            let timeline = Timeline(entries: entries, policy: .never)
            
            // Pass the timeline to the completion handler.
            completion(timeline)
        }
    }
}

struct GlucoseEntry: TimelineEntry {
    let date: Date
    let mgCaffeine: Double
    let totalCups: Double
    
    let glucoseAndTrendText = "120↘︎"
    let glucoseText = "120"
    let timeText = "3MIN"
}

struct CircularComplication: View {
    /// The widget's rendering mode.
    @Environment(\.widgetRenderingMode) var renderingMode
    
    var mgCaffeine: Double
    var totalCups: Double
    let maxMG = 250.0
    
    var body: some View {
        Gauge( value: min(mgCaffeine, maxMG), in: 0.0...maxMG ) {
            Text("mg")
        } currentValueLabel: {
            if renderingMode == .fullColor {
                // Add a foreground color to the label.
                Text(mgCaffeine.description)
                    .foregroundColor(.red)
            }
            else {
                // Otherwise, use the default text color.
                Text(mgCaffeine.description)
            }
        }
        .gaugeStyle(
            // Add a gradient to the gauge.
            CircularGaugeStyle(tint: .red)
        )
    }
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry
    
    /// The widget's family
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularComplication(
                mgCaffeine: entry .mgCaffeine,
                totalCups: entry.totalCups
            )
        case .accessoryCorner:
            fatalError("Not implemented")
        case .accessoryInline:
            fatalError("Not implemented")
        case .accessoryRectangular:
            fatalError("Not implemented")
        @unknown default:
            fatalError("Not implemented")
        }
    }
}

@main
struct Widgets: Widget {
    let kind: String = "Widgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Loop Glucose Data")
        .description("Latest glucose data via Loop")
        .supportedFamilies([.accessoryCircular]) // TODO: Add support for remaining families
    }
}
