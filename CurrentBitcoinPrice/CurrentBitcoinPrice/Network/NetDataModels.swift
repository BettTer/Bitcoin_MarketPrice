//
//  NetDataModels.swift
//  CurrentBitcoinPrice
//
//  Created by X Young. on 2019/10/27.
//  Copyright © 2019 X Young. All rights reserved.
//

import UIKit
import HandyJSON

class ChartInfo: HandyJSON {
    /// 状态
    var status: String!
    /// 类别
    var name: String!
    /// 货币单位
    var unit: String!
    /// 单位时间
    var period: String!
    /// 描述
    var description: String!
    /// 值
    var values: [ChartValue]!
    
    required init() {
        
    }
}

class ChartValue: HandyJSON {
    /// 时间
    var x: Double = 0
    /// 值
    var y: Double = 0
    
    required init() {
        
    }
}
