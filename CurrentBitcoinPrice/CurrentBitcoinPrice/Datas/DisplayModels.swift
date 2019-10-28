//
//  DisplayModels.swift
//  CurrentBitcoinPrice
//
//  Created by X Young. on 2019/10/27.
//  Copyright © 2019 X Young. All rights reserved.
//

import UIKit

class ComponentManager: NSObject {
    /// 跳转系统设置界面
    static func jumpToSysSettingPage() -> Void {
        
        DispatchQueue.main.async {
            let url = URL(string: UIApplication.openSettingsURLString)
            
            let alertVC = UIAlertController.quickInit(
                title: "是否前往设置页面打开权限?",
                optionTitles: ["确定"],
                optionAction: { (_) in
                    
                    if  UIApplication.shared.canOpenURL(url!) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url!, options: [:],completionHandler: {(success) in})
                        } else {
                            UIApplication.shared.openURL(url!)
                        }
                    }
                    
            })
            
            UIApplication.shared.windows[0].rootViewController!.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
}
