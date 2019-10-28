//
//  HomePageVC.swift
//  CurrentBitcoinPrice
//
//  Created by X Young. on 2019/10/24.
//  Copyright © 2019 X Young. All rights reserved.
//

import UIKit
import SwiftCharts
import Timepiece

class HomePageVC: BaseViewController {
    // MARK: - UI =====>
    var chart: Chart?
    
    var currentPositionLabels: [UILabel] = []
    
    // MARK: - 记录 =====>
    private var didLayout: Bool = false
    
    private var timespan: EnumSet.Timespan = .thirty_Days {
        didSet {
            if timespan != oldValue {
                
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem!.title = self.timespan.rawValue
                    
                    if self.chart != nil {
                        self.chart!.view.removeFromSuperview()
                        
                        self.currentPositionLabels.forEach { (label) in
                            label.removeFromSuperview()
                        }
                        
                    }
                    
                    self.drawGraph()
                }
                
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Graph"
        
        self.drawGraph()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
            title: timespan.rawValue,
            style: .done,
            target: self,
            action: #selector(self.clickRightItem))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.didLayout == false {
            self.didLayout = true
            
        }
    }

}

extension HomePageVC {
    /// 绘制图像
    private func drawGraph() -> Void {
        RequestManager.shared.getBlockchainData(
            timespan: timespan,
            callBack: { (chartInfo) in
                
                DispatchQueue.main.async{
                    if chartInfo == nil {
                        self.title = "网络错误..."
                        
                    }else {
                        self.initChart(chartInfo!)
                        self.title = chartInfo!.name
                        
                    }
                }
            }
        )
        
    }
    
    /// 初始化
    private func initChart(_ chartInfo: ChartInfo) {
        
        let labelSettings = ChartLabelSettings(font: EnumSet.font(.normal, size: 11))
        
        var chartPoints: [ChartPoint] = []
        
        chartInfo.values.forEach { (chartValue) in
            let itemDate = Date.init(timeIntervalSince1970: chartValue.x)
            let daysBetween = Date.today().daysBetweenDate(toDate: itemDate)
            
            let chartPoint = ChartPoint(
                x: ChartAxisValueDouble(daysBetween),
                y: ChartAxisValueDouble(chartValue.y))
            
            chartPoints.append(chartPoint)
            
        }
        
        let xValues: [ChartAxisValue] = {
            var tmpArray: [ChartAxisValue] = []
            
            let unit = Int(chartPoints.last!.x.scalar - chartPoints.first!.x.scalar) / 29
            
            for index in 0 ..< 30 {
                let chartAxisValue = ChartAxisValueDouble.init(Int(chartPoints.first!.x.scalar) + unit * index)
                
                tmpArray.append(chartAxisValue)
                
            }
            
            return tmpArray
        }()
            
        let yValues: [ChartAxisValue] = {
            var tmpArray: [ChartAxisValue] = []
            
            let chartValue_MaxY = chartInfo.values.max { (chartValue1, chartValue2) -> Bool in
                
                return chartValue1.y < chartValue2.y
            }
            
            let chartValue_MinY = chartInfo.values.min { (chartValue1, chartValue2) -> Bool in
                
                return chartValue1.y < chartValue2.y
            }
            
            let range = Int(chartValue_MinY!.y) / 1000 ... Int(chartValue_MaxY!.y) / 1000 + 1
            
            for index in range {
                let axisValue = ChartAxisValue.init(scalar: Double(index * 1000))
                tmpArray.append(axisValue)
                
            }
            
            return tmpArray
        }()
        
        let xModel = ChartAxisModel(
            axisValues: xValues,
            axisTitleLabel: ChartAxisLabel(
                text: "Date",
                settings: labelSettings))
        
        let yModel = ChartAxisModel(
            axisValues: yValues,
            axisTitleLabel: ChartAxisLabel(
                text: chartInfo.unit,
                settings: labelSettings.defaultVertical()))
        
        let chartFrame = DisplayDefaults.chartFrame(self.view.bounds)
        let chartSettings = DisplayDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(
            chartPoints: chartPoints,
            lineColor: UIColor.systemBlue, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel], useView: false)
        
        let thumbSettings = ChartPointsLineTrackerLayerThumbSettings(thumbSize: 10, thumbBorderWidth: 2)
        let trackerLayerSettings = ChartPointsLineTrackerLayerSettings(thumbSettings: thumbSettings)
        
        
        
        let chartPointsTrackerLayer = ChartPointsLineTrackerLayer<ChartPoint, Any>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lines: [chartPoints], lineColor: UIColor.systemPink, animDuration: 1, animDelay: 2, settings: trackerLayerSettings) {chartPointsWithScreenLoc in

            self.currentPositionLabels.forEach{$0.removeFromSuperview()}
            
            for (_, chartPointWithScreenLoc) in chartPointsWithScreenLoc.enumerated() {
                
                let chartPoint = chartPointWithScreenLoc.chartPoint
                let xScalar = chartPoint.x.scalar
                let closeChartPoint: ChartPoint = {
                    
                    for index in 0 ..< chartPoints.count {
                        let chartPoint = chartPoints[index]
                        
                        if xScalar <= chartPoint.x.scalar {
                            return chartPoint
                            
                        }
                    }
                    
                    return chartPoints.last!
                }()

                let label = UILabel()
                label.numberOfLines = 2
                
                let date = Date.init(timeIntervalSinceNow: TimeInterval(Int(closeChartPoint.x.scalar) * 24 * 60 * 60))
                
                let dateText = date.dateString(in: .medium)
                
                label.text = dateText + "\n" + chartInfo.unit + ": " + String(closeChartPoint.y.scalar.roundTo(places: 2))
                
                label.sizeToFit()
                
                
                
                label.center = CGPoint(x: chartPointWithScreenLoc.screenLoc.x, y: chartPointWithScreenLoc.screenLoc.y + chartFrame.minY - label.getHeight() / 2)

                label.backgroundColor = UIColor.systemBlue
                label.textColor = UIColor.white

                self.currentPositionLabels.append(label)
                self.view.addSubview(label)
            }
        }
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.systemPink, linesWidth:0.1)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer,
                chartPointsTrackerLayer
            ]
        )
        
        view.addSubview(chart.view)
        self.chart = chart
        
    }
}

extension HomePageVC {
    /// <#功能#>
    @objc func clickRightItem() -> Void {
        var optionTitles: [String] = []
        
        for item in EnumSet.Timespan.allCases {
            optionTitles.append(item.rawValue)
            
        }
        
        
        let alertVC = UIAlertController.quickInit(
            title: "Plz pick one timespan",
            optionTitles: optionTitles,
            optionAction: { (index) in
                self.timespan = EnumSet.Timespan.allCases[index]
                
        })
        
        alertVC.modalPresentationStyle = .fullScreen
        self.present(
            alertVC,
            animated: true,
            completion: {
                
        })
        
    }
    
}
