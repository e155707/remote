//
//  MainIphoneController.swift
//  AfuRo
//
//  Created by e155707 on 2017/12/04.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//


import UIKit
import SceneKit
import ARKit
import MapKit
import Social
import AVFoundation
import Accounts

class MainIphoneController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    let cameraController = CameraController()
    let login = Login()
    
    let anglex = -89.6
    
    var audioPlayerInstance : AVAudioPlayer! = nil
    
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
    @IBOutlet var cameraButton: UIButton!
    
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
    
    // ヘルスケアから取ってきた歩数を保存する変数
    var healthStepsData = 0
    
    // Afuroの増える大きさを調整する係数.
    // 今の計算式 アフロの大きさ = 1 + 歩数(totalStepsData) * afuroScaleCoeff
    let afuroScaleCoeff:Float = 0.001;
    
    let dataController = DataController()
    let healthDataController = HealthDataController()
    
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
            let afuroScene = SCNScene(named: "art.scnassets/daefile/afuro.scn"),
            let afuroNode = afuroScene.rootNode.childNode(withName:"afuro" , recursively: true)
            else{ return }
        
       // setLocationManager()
        
        // これまでの歩数の取得
        totalStepsData = dataController.getTotalStepsData() + getStepsHealthKit()
        print("totalStepsDate =\(dataController.getTotalStepsData())")
        
        // アフロの位置
        afuroNode.position = SCNVector3(0,0,afuroNode.scale.z/2)
        
        afuroNode.position = SCNVector3(0,0,-3)
        // アフロの回転
        afuroNode.eulerAngles = SCNVector3(anglex,0,0)
        
        totalStepsData += login.loginGetSteps()
        if Login().isDailyFirstLogin(dataController.getLastDateData()){
            //self.createSelectElementWindow()
        }
        
        self.createSelectElementWindow()
        
        // アフロの大きさの調整
        afuroNode.scale.x = 1 + Float(totalStepsData) * afuroScaleCoeff
        afuroNode.scale.y = 1 + Float(totalStepsData) * afuroScaleCoeff
        afuroNode.scale.z = 1 + Float(totalStepsData) * afuroScaleCoeff
        
        //createSelectElementWindow()
        ARView.scene.rootNode.addChildNode(afuroNode)
        
        // アプリ終了時にsaveDataを呼ぶための関数.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(self.saveData),
            name:NSNotification.Name.UIApplicationWillTerminate,
            object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        // サウンドファイルのパスを生成
        let soundFilePath = Bundle.main.path(forResource: "camera", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        // AVAudioPlayerのインスタンスを作成
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成失敗")
        }
        // バッファに保持していつでも再生できるようにする
        audioPlayerInstance.prepareToPlay()
    }
    
    @IBAction func share(_ sender: UIButton) {
        // 共有する項目
        let shareText = "#Aruke"
        //let shareWebsite = NSURL(string: "https://www.apple.com/jp/watch/")!
        let shareImage = ARView.snapshot()
        
        let activityItems = [shareText, shareImage] as [Any]
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityType.postToFacebook,
            //UIActivityType.postToTwitter,
            UIActivityType.message,
            UIActivityType.saveToCameraRoll,
            UIActivityType.print
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func reload(_ sender: Any) {
        //ARView.scene.rootNode.childNode(withName: "afuro", recursively: false)?.runAction(SCNAction.removeFromParentNode())
        
        guard
            let afuroNode = ARView.scene.rootNode.childNode(withName: "afuro", recursively: true)
            else {return}
        
        // これまでの歩数の取得
        //totalStepsData = dataController.getTotalStepsData()
        //print("totalStepsDate =\(dataController.getTotalStepsData())")
        
        // アフロの位置
        afuroNode.position = SCNVector3(0,0,-3)
        
        var r:Float = 5
        
        let phi:Float = (ARView.pointOfView?.eulerAngles.x)!
        let thete:Float = (ARView.pointOfView?.eulerAngles.y)!
        
        if(cos((ARView.pointOfView?.eulerAngles.x)!) >= 0){
            r = -3
        }else{
            r = 3
        }
        
        afuroNode.position.x = r*sin(thete)*cos(phi)
        afuroNode.position.y = -r*sin(thete)*sin(phi)
        afuroNode.position.z = r*cos(thete)
        
        print("--------------------------------------")
        print("x:",afuroNode.position.x)
        print("y:",afuroNode.position.y)
        print("z:",afuroNode.position.z)
        
        // アフロの回転
        afuroNode.eulerAngles = SCNVector3(anglex,0,0)
        
        //self.createSelectElementWindow()
        
        // アフロの大きさの調整
        afuroNode.scale.x = 1 + Float(totalStepsData) * afuroScaleCoeff
        afuroNode.scale.y = 1 + Float(totalStepsData) * afuroScaleCoeff
        afuroNode.scale.z = 1 + Float(totalStepsData) * afuroScaleCoeff
        
        //createSelectElementWindow()
        //ARView.scene.rootNode.addChildNode(afuroNode)
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
        //plusButton.tag = ButtonTag.Plus.rawValue;
        // タップされている間, moveNodeを呼ぶよう設定.
        //plusButton.addTarget(self, action: #selector(self.touchButtonScale), for: .touchDown)
        
        // アフロを大きくさせるボタンの設定.
        // タグの設定.
        //minusButton.tag = ButtonTag.Minus.rawValue;
        // タップされている間, moveNodeを呼ぶよう設定.
        //minusButton.addTarget(self, action: #selector(self.touchButtonScale), for: .touchDown)
        
        cameraButton.addTarget(self, action: #selector(self.shutter), for: .touchDown)
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
    
    @objc func shutter(){
        
        audioPlayerInstance.play()
        cameraController.savePicture(ARView.snapshot())
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
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    var selectElementWindow:UIWindow!
    
    func createSelectElementWindow(){
        selectElementWindow = UIWindow()
        // 背景を黒に設定する.
        selectElementWindow.backgroundColor = UIColor.black
        
        if let image = UIImage(named: "login") {
            selectElementWindow?.layer.contents = image.cgImage
        }
        
        selectElementWindow.frame = CGRect(x: 50, y: 150, width: 275, height: 450)
        selectElementWindow.alpha = 1.0
        
        // myWindowをkeyWindowにする.
        selectElementWindow.makeKey()
        
        // windowを表示する.
        self.selectElementWindow.makeKeyAndVisible()
        
        let tapSelectElementWindowGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapSelectElementWindow))
        
        selectElementWindow.addGestureRecognizer(tapSelectElementWindowGesture)
        print("tap1")
        
    }
    
    @objc func tapSelectElementWindow(){
        selectElementWindow = nil
        print("tap2")
    }
    
    func getStepsHealthKit() -> Int{
        let healthDataController = HealthDataController()
        // ヘルスケアから取ってきた歩数を保存する変数
        var healthStepsData = 0
        // ヘルスケアのデータの取得
        if healthDataController.checkAuthorization() {
            // もしヘルスケアのアクセスがtrueなら, 今の時刻と最後に歩いた時刻の間の歩いた数の合計を取得.
            healthStepsData = healthDataController.getStepsHealthKit(startDate: dataController.getLastDateData(), endDate: Date())
            print("healthDate = \(healthStepsData)")
        }else{
            // // もしヘルスケアにアクセスできないなら, ダミー関数を取得.
            healthStepsData = healthDataController.getDummyStepsData()
        }
        
        return healthStepsData
    }
    
    let locationManager = CLLocationManager()
    var oldLocation: CLLocation?
    
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
            ErrorController().notGetLocation()
            break
            
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            ErrorController().notGetLocation()
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
