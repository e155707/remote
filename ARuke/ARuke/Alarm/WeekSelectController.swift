//
//  WeekSelectController.swift
//  
//
//  Created by e155707 on 2017/11/07.
//

import Foundation
import UIKit
import SceneKit

class WeekSelectController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    let week = [
        "月曜日",
        "火曜日",
        "水曜日",
        "木曜日",
        "金曜日",
        "土曜日",
        "日曜日"
    ]
    
    let timeManager:TimeManager = TimeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // trueで複数選択、falseで単一選択
        tableView.allowsMultipleSelection = true
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(tableView)
    }
    
    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        
        timeManager.setDayOfTheWeek(indexPath.row)
        
        // チェックマークを入れる
        cell?.accessoryType = .checkmark
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        
        timeManager.resetDayOfTheWeek(indexPath.row)
        
        // チェックマークを外す
        cell?.accessoryType = .none
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(week[indexPath.row])"
        
        // セルが選択された時の背景色を消す
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
}
