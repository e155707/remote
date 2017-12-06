//
//  ViewController.swift
//  AfuRo
//
//  Created by 赤堀　貴一 on 2017/11/26.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MapKit

class MainController: UIViewController, ARSCNViewDelegate,CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var oldLocation: CLLocation?
    
    @IBOutlet var ARView: ARSCNView!
    //var ARView:ARSCNView?
    // ボタンを追加
    //@IBOutlet var afuroView: UIView!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var downButton: UIButton!

    // アフロの大きさを調整するボタン
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    
    @IBOutlet weak var ARSwitch: UISwitch!
    
    @IBOutlet weak var AROnOffLabel: UILabel!
    
    enum ButtonTag: Int {
        case Right = 1
        case Left = 2
        case Up = 3
        case Down = 4
        case Plus = 5
        case Minus = 6
    }
    
    // ボタンを押した時に, 移動する量を調整する.
    let moveAmount:Float = 0.1;
    
    // 合計の歩いた数を格納する変数
    var totalStepsData = 0
    
    // Afuroの増える大きさを調整する係数.
    // 今の計算式 アフロの大きさ = 1 + 歩数(totalStepsData) * afuroScaleCoeff
    let afuroScaleCoeff:Float = 1;
    
    let dataController = DataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        ARView.delegate = self
        
        // Show statistics such as fps and timing information
        ARView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        ARView.scene = scene
        initMoveButton();
        guard
            let afuroScene = SCNScene(named: "art.scnassets/daefile/aforo.scn"),
            let afuroNode = afuroScene.rootNode.childNode(withName:"afuro" , recursively: true)
        else{ return }
        
        setLocationManager()

        // これまでの歩数の取得
        totalStepsData = dataController.getTotalStepsData()
        print("totalStepsDate =\(dataController.getTotalStepsData())")
        // アフロの位置
        afuroNode.position = SCNVector3(0,0,1)
        
        afuroNode.position = SCNVector3(0,0,-3)
        // アフロの回転
        afuroNode.eulerAngles = SCNVector3(-90,0,0)
        
        totalStepsData += Login().loginGetSteps()
        
        // アフロの大きさの調整
        afuroNode.scale.x = 1 + Float(totalStepsData) * afuroScaleCoeff
        afuroNode.scale.y = 1 + Float(totalStepsData) * afuroScaleCoeff
        afuroNode.scale.z = 1 + Float(totalStepsData) * afuroScaleCoeff

        
        ARView.scene.rootNode.addChildNode(afuroNode)
        
        ARSwitch.addTarget(self, action: #selector(MainController.onClickARSwitch(sender:)), for: UIControlEvents.valueChanged)
        
        AROnOffLabel.text = "on"
        AROnOffLabel.textColor = UIColor.red
        
        
        // アプリ終了時にsaveDataを呼ぶための関数.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(self.saveData),
            name:NSNotification.Name.UIApplicationWillTerminate,
            object: nil)
    }
    
    // データを保存する関数.
    @objc func saveData(){
        dataController.setTotalStepsData(totalStepsData)
        
    }
    
    // アフロを移動させるボタンの設定.
    func initMoveButton(){
        /* ボタンのタグの意味 上のenumを参照
         *  1 : 右のボタン.
         *  2 : 左のボタン.
         *  3 : 上のボタン.
         *  4 : 下のボタン.
         *  5 : アフロが大きくなるボタン.
         *  6 : アフロが小さくなるボタン.
         */
    
        // 右に移動させるボタンの設定.
        // タグの設定.
        rightButton.tag = ButtonTag.Right.rawValue;
        // タップされている間, moveNodeを呼ぶよう設定.
        rightButton.addTarget(self, action: #selector(self.touchButtonMoveNode), for: .touchDown)

        // 左に移動させるボタンの設定.
        // タグの設定.
        leftButton.tag = ButtonTag.Left.rawValue;
        // タップされている間, moveNodeを呼ぶよう設定.
        leftButton.addTarget(self, action: #selector(self.touchButtonMoveNode), for: .touchDown)
        
        // 上に移動させるボタンの設定.
        // タグの設定.
        upButton.tag = ButtonTag.Up.rawValue;
        // タップされている間, moveNodeを呼ぶよう設定.
        upButton.addTarget(self, action: #selector(self.touchButtonMoveNode), for: .touchDown)
        
        // 下に移動させるボタンの設定.
        // タグの設定.
        downButton.tag = ButtonTag.Down.rawValue;
        // タップされている間, moveNodeを呼ぶよう設定.
        downButton.addTarget(self, action: #selector(self.touchButtonMoveNode), for: .touchDown)
        
        // アフロを大きくさせるボタンの設定.
        // タグの設定.
        plusButton.tag = ButtonTag.Plus.rawValue;
        // タップされている間, moveNodeを呼ぶよう設定.
        plusButton.addTarget(self, action: #selector(self.touchButtonScale), for: .touchDown)
        
        // アフロを大きくさせるボタンの設定.
        // タグの設定.
        minusButton.tag = ButtonTag.Minus.rawValue;
        // タップされている間, moveNodeを呼ぶよう設定.
        minusButton.addTarget(self, action: #selector(self.touchButtonScale), for: .touchDown)
    }
    
    // ボタンがタップされた時に呼び出されるメソッド
    @objc func touchButtonMoveNode(_ moveButton: UIButton){
        guard
            let afuroNode = ARView.scene.rootNode.childNode(withName: "afuro", recursively: true)
            else{ print("afuroが...ない!"); return}
        // afuroを移動させる.
        switch moveButton.tag {
        case ButtonTag.Right.rawValue:
            
            afuroNode.position.x += moveAmount * 1
            print("right")
            break
        case ButtonTag.Left.rawValue:
            afuroNode.position.x += moveAmount * -1
            print("left")
            break
        case ButtonTag.Up.rawValue:
            afuroNode.position.y += moveAmount * 1
            print("up")
            break
        case ButtonTag.Down.rawValue:
            afuroNode.position.y += moveAmount * -1
            print("down")
            break

        default:
            return
        }
        
    }
    
    //
    @objc func touchButtonScale(_ moveButton: UIButton){
        guard
            let afuroNode = ARView.scene.rootNode.childNode(withName: "afuro", recursively: true)
            else{ print("afuroが...ない!"); return}
        // afuroを移動させる.
        switch moveButton.tag {
            
        case ButtonTag.Plus.rawValue:
            afuroNode.scale.x += afuroScaleCoeff * 1
            afuroNode.scale.y += afuroScaleCoeff * 1
            afuroNode.scale.z += afuroScaleCoeff * 1
            print("plus")
            break
            
        case ButtonTag.Minus.rawValue:
            afuroNode.scale.x += afuroScaleCoeff * -1
            afuroNode.scale.y += afuroScaleCoeff * -1
            afuroNode.scale.z += afuroScaleCoeff * -1
            print("minus")
            break
            
        default:
            return
        }
    }
    
    
    @objc func onClickARSwitch(sender: UISwitch){
        if sender.isOn {
            AROnOffLabel.text = "on"
            AROnOffLabel.textColor = UIColor.red
        }else {
            AROnOffLabel.text = "off"
            AROnOffLabel.textColor = UIColor.blue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        ARView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        ARView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func getStepsHealthKit() -> Int{
        let healthDataController = HealthDataController()
        // ヘルスケアから取ってきた歩数を保存する変数
        var healthStepsData = 0
        // ヘルスケアのデータの取得
        if healthDataController.checkAuthorization() {
            // もしヘルスケアのアクセスがtrueなら, 今の時刻と最後に歩いた時刻の間の歩いた数の合計を取得.
            healthStepsData = healthDataController.getStepsHealthKit(startDate: dataController.getLastDateData(), endDate: Date())
        }else{
            // // もしヘルスケアにアクセスできないなら, ダミー関数を取得.
            healthStepsData = healthDataController.getDummyStepsData()
        }
        
        return healthStepsData
    }
    
    
    
    // 位置情報の設定
    func setLocationManager(){
        
        // 現在位置情報の精度, 誤差を決定. 以下の様なものがある
        // - kCLLocationAccuracyBestForNavigation ナビゲーションに最適な値
        // - kCLLocationAccuracyBest 最高精度(iOS,macOSのデフォルト値)
        // - kCLLocationAccuracyNearestTenMeters 10m
        // - kCLLocationAccuracyHundredMeters 100m（watchOSのデフォルト値）
        // - kCLLocationAccuracyKilometer 1Km
        // - kCLLocationAccuracyThreeKilometers 3Km
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 現在位置からどれぐらい動いたら更新するか. 単位はm
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    
    // 位置情報がlocationManager.distanceFilterの値分更新された時に呼び出されるメソッド.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        
        if oldLocation == nil {
            oldLocation = location
        }
        
        let locationDistance = location.distance(from: oldLocation!)
        print("moveDistance = \(locationDistance)")
        totalStepsData += Int(locationDistance)
        saveData()
        oldLocation = location
        
    }
    
    //起動時と, 位置情報のアクセス許可が変更された場合に呼び出されるメソッド. ここで位置情報のアクセス許可をとる.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            // 位置情報アクセスを常に許可するかを問いかける
            locationManager.requestAlwaysAuthorization()
            
            break
            
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 位置情報アクセスを常に許可するかを問いかける
            locationManager.requestAlwaysAuthorization()
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            MapErrorController().notGetLocation()
            break
            
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            MapErrorController().notGetLocation()
            break
            
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            
            
            break
            
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
    
            locationManager.requestAlwaysAuthorization()
            // 位置情報取得の開始処理
            break
            
        }
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
