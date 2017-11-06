//
//  TimeController.swift
//  ARuke
//
//  Created by e155707 on 2017/11/04.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class TimeController{
    
    func getNowTime()-> String {
        // 現在時刻を取得
        let nowTime: NSDate = NSDate()
        // 成形する
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        let nowTimeStr = format.string(from: nowTime as Date)
        // 成形した時刻を文字列として返す
        return nowTimeStr
    }
}
