//
//  UISwitchMini.swift
//  AfuRo
//
//  Created by e155707 on 2017/11/27.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit

class UIARSwitch:UISwitch{
    @IBInspectable var dispSize: CGSize = CGSize(width: 51.0, height: 31.0) //iOS10での標準サイズをいれている
    override func awakeFromNib() {
        super.awakeFromNib()
        let scaleX: CGFloat = dispSize.width / self.bounds.size.width
        let scaleY: CGFloat = dispSize.height / self.bounds.size.height
        print("[bounds:\(NSStringFromCGRect(self.bounds))] [frame:\(NSStringFromCGRect(self.frame))]")
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        print("[bounds:\(NSStringFromCGRect(self.bounds))] [frame:\(NSStringFromCGRect(self.frame))]")
    }
}
