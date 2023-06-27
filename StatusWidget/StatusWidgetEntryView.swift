//
//  SmallStatusWidgetEntryView.swift
//  Loop
//
//  Created by Pete Schwamb on 11/23/22.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import SwiftUI

struct StatusWidgetEntryView : View {
    var entry: StatusWidgetProvider.Entry

    @Environment(\.widgetFamily)
    var family
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularStatusWidgetEntryView(entry: entry)
        default:
            SmallStatusWidgetEntryView(entry: entry)
        }
    }
}
