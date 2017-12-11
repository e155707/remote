//
//  Login.swift
//  AfuRo
//
//  Created by 赤堀　貴一 on 2017/11/30.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation

class Login{
    
    var loginWindow: UIWindow!
    
    let dataController = DataController()

    // ログインボーナス.
    let loginDayAddSteps = 10
    // 1日ログインしていない場合に減る歩数.
    let oneDayLossSteps = 10
    
    func loginGetSteps() -> Int{

        // 歩数
        var bonasSteps = 0
        
        // 最後にログインした日を取得.
        let lastLoginDate = dataController.getLastDateData()
        
        // もし, 一日の初めてのログインなら, bonasStepsにログインボーナスなどを足す.
        if self.isDailyFirstLogin(lastLoginDate) {
            
            bonasSteps += self.loginBonasGetSteps()
            bonasSteps -= self.notLoginBonasGetSteps(lastLoginDate)
        }
        // ログインした日にちを更新
        dataController.setLastDateData(Date())
        // リターンする.
        return bonasSteps
    }
    
    // ダミー関数を返す.
    func dummyLoginGetSteps() -> Int {
         let calendar = Calendar.current
         let Days2Ago = calendar.date(byAdding: .day, value: -2, to: Date())
         dataController.setLastDateData(Days2Ago!)

        return self.loginGetSteps()
    }
    
    func loginBonasGetSteps() -> Int{
        return loginDayAddSteps
    }
    
    func notLoginBonasGetSteps(_ lastLoginDate: Date) -> Int{
        let notLoginDays = self.getNotLoginDay(lastLoginDate)
        return notLoginDays * oneDayLossSteps
        
    }
    
    // この日最初のログインかどうかを判定
    func isDailyFirstLogin(_ lastDate: Date) -> Bool{
        let notLoginDay = getNotLoginDay(lastDate)
        
        if notLoginDay == 0{
            return false
        }
        return true
    }

    // ログイン
    func getNotLoginDay(_ lastDate: Date) -> Int{
        var notLoginDayCount = 0
        let nowDate = roundDate(Date())
        let lastLoginDate = roundDate(lastDate)
        let diffDate = Calendar.current.dateComponents([.day], from:lastLoginDate, to:nowDate)
        if diffDate.day != nil {
            notLoginDayCount = diffDate.day!
        }else {
            print("ログインしていない日数の取得に失敗しました.")
        }
        
        return notLoginDayCount
    }
    // Dateから年日月を抽出する関数
    func roundDate(_ date: Date, calendar cal: Calendar = Calendar.current) -> Date {
        return cal.date(from: DateComponents(year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date)))!
    }
    
}
