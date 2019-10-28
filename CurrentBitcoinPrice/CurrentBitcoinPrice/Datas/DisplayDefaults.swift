//
//  DisplayDefaults.swift
//  CurrentBitcoinPrice
//
//  Created by X Young. on 2019/10/27.
//  Copyright © 2019 X Young. All rights reserved.
//

import UIKit
import SwiftCharts

struct DisplayDefaults {
    
    static func chartFrame(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 25, y: 50, width: containerBounds.size.width - 25, height: containerBounds.size.height - 50)
    }
    
    
    static var chartSettingsWithPanZoom: ChartSettings {
        var chartSettings = normalChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        
        return chartSettings
    }
    
    fileprivate static var normalChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        
        return chartSettings
    }
    
}
