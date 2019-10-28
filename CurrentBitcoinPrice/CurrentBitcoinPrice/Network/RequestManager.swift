//
//  RequestManager.swift
//  CurrentBitcoinPrice
//
//  Created by X Young. on 2019/10/24.
//  Copyright © 2019 X Young. All rights reserved.
//

import UIKit
import Reachability
import Alamofire
import CoreTelephony

class RequestManager: NSObject {
    static let shared = RequestManager.init()
    
    private let requestPrefix = "https://api.blockchain.info/charts/market-price"
    
    private let rightStatusMark = "ok"
    
}

extension RequestManager {
    /// get and manipulate data behind all Blockchain.info's charts.
    func getBlockchainData(timespan: EnumSet.Timespan, callBack: @escaping (ChartInfo?) -> Void) -> Void {
        
//        if self.decideNetworkService() == false {
//            
//            ComponentManager.jumpToSysSettingPage()
//            
//            callBack(nil)
//            return
//        }
        
        
        if self.decideNetworkStatusIsAvailable() == false {
            callBack(nil)
            
            return
        }
        
        AF.request(
            requestPrefix,
            parameters: ["timespan": timespan.rawValue]).responseString { (response) in
                            
                if response.error == nil {
                    
                    if let chartInfo = ChartInfo.deserialize(from: response.value) {
                        
                        if chartInfo.status == self.rightStatusMark {
                            callBack(chartInfo)
                            
                        }else {
                            callBack(nil)
                            
                        }
                        
                        
                        
                    }else {
                        callBack(nil)
                        
                    }
                    
                    
                    
                }else {
                    callBack(nil)
                    
                }
                    
            }

        }
    
    
}

extension RequestManager {
    /// 监测当前网络状态是否可用
    func decideNetworkStatusIsAvailable() -> Bool {
        
        let reachability = try! Reachability()
        
        let networkStatus = reachability.connection
        
        switch networkStatus {
        case .unavailable:
            return false
        
        case .wifi:
            return true
            
        case .cellular:
            return true
            
        default:
            return false
            
        }
    }
    
    /// 检测网络权限
    func decideNetworkService() -> Bool {
        let cellularData = CTCellularData()
        
        let state = cellularData.restrictedState
        
        if state == CTCellularDataRestrictedState.restrictedStateUnknown
            ||  state == CTCellularDataRestrictedState.notRestricted {
            return false
            
        } else {
            return true
            
        }
        
    }
    
}
