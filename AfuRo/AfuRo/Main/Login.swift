//
//  Login.swift
//  AfuRo
//
//  Created by 赤堀　貴一 on 2017/11/30.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation

class Login{
    let dataController = DataController()
    let oneDayLossSteps = 10
    
    func login(){
        // Debug用
        /*
         let calendar = Calendar.current
         let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
         dataController.setLastDateData(yesterday!)
         */
        
        let lastLoginDate = dataController.getLastDateData()
        if self.isDailyFirstLogin(lastLoginDate) {
            let notLoginDays = self.getNotLoginDay(lastLoginDate)
            self.loginBonas()
            self.notLoginBonas(notLoginDays)
        }
        dataController.setLastDateData(Date())
    }
    
    func loginBonas() {
        
    }
    
    func notLoginBonas(_ notLoginDays: Int){
        let lossSteps = notLoginDays * oneDayLossSteps
        
    }
    
    func isDailyFirstLogin(_ lastDate: Date) -> Bool{
        let notLoginDay = getNotLoginDay(lastDate)
        
        if notLoginDay == 0{
            return false
        }
        return true
    }

    
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
