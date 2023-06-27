//
//  CircularStatusWidgetEntryView.swift
//  Loop
//
//  Created by David Feinzimer on 6/27/23.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation

import SwiftUI
import LoopUI

struct CircularStatusWidgetEntryView : View {
    var entry: StatusWidgetProvider.Entry
    
    var body: some View {
        LoopCircleView(entry: entry)
            .background(
                ContainerRelativeShape()
                    .fill(Color("WidgetSecondaryBackground"))
            )
    }
}
