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
    
    var audioPlayerInstance : AVAudioPlayer! = nil
    
    @IBOutlet var ARView: ARSCNView!
    //var ARView:ARSCNView?
    // ボタンを追加
    //@IBOutlet var afuroView: UIView!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var downButton: UIButton!
    
    // カメラボタン
    @IBOutlet var cameraButton: UIButton!
    
    enum ButtonTag: Int {
        case Right = 1
        case Left = 2
        case Up = 3
        case Down = 4
    }
    
    // ボタンを押した時に, 移動する量を調整する.
    let moveAmount:Float = 0.1;
    
    // 合計の歩いた数を格納する変数
    var totalStepsData = 0

    let dataController = DataController()
    let healthDataController = HealthDataController()
    let cameraController = CameraController()
    let login = Login()
    
    var afuro:Afuro!
    
    var lastDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        ARView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        ARView.scene = scene
        initMoveButton();
        
        lastDate = dataController.getLastDateData()
        totalStepsData = dataController.getTotalStepsData() + getStepsHealthKit()
        totalStepsData += login.loginGetSteps()
        
        print("totalStepsDate = \(totalStepsData)")
        
        saveData()
        
        if login.isDailyFirstLogin(lastDate){
            //self.createSelectElementWindow()
        }
        
        self.createSelectElementWindow()
        
        afuro = Afuro(steps: totalStepsData)

        ARView.scene.rootNode.addChildNode(afuro)
        
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
        
        // 歩数の取得
        //getStepsHealthKit()
        print("totalStepsDate =\(totalStepsData)")
        
        // Debug
        //afuro.addScale(steps: 100)

        afuro.addScale(steps: getStepsHealthKit())
        
        var r:Float = -2
        
        let phi:Float = (ARView.pointOfView?.eulerAngles.x)!
        let thete:Float = (ARView.pointOfView?.eulerAngles.y)!
        
        if(cos((ARView.pointOfView?.eulerAngles.x)!) >= 0){
            r = -2 + -1*afuro.scale.z
            
        }else{
            r = 2 + -1*afuro.scale.z
        }
        
        afuro.position.x = r*sin(thete)*cos(phi)
        afuro.position.y = -r*sin(thete)*sin(phi)
        afuro.position.z = r*cos(thete)
        
        print("--------------------------------------")
        print("x:",afuro.position.x)
        print("y:",afuro.position.y)
        print("z:",afuro.position.z)

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
        
        
        cameraButton.addTarget(self, action: #selector(self.shutter), for: .touchDown)
    }
    
    // ボタンがタップされた時に呼び出されるメソッド
    @objc func touchButtonMoveNode(_ moveButton: UIButton){
        // afuroを移動させる.
        switch moveButton.tag {
        case ButtonTag.Right.rawValue:
            
            afuro.position.x += moveAmount * 1
            print("right")
            break
        case ButtonTag.Left.rawValue:
            afuro.position.x += moveAmount * -1
            print("left")
            break
        case ButtonTag.Up.rawValue:
            afuro.position.y += moveAmount * 1
            print("up")
            break
        case ButtonTag.Down.rawValue:
            afuro.position.y += moveAmount * -1
            print("down")
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
            healthStepsData = healthDataController.getStepsHealthKit(startDate: lastDate, endDate: Date())
            lastDate = Date()
            print("healthDate = \(healthStepsData)")
            
        }else{
            // // もしヘルスケアにアクセスできないなら, ダミー関数を取得.
            healthStepsData = healthDataController.getDummyStepsData()
        }
        
        return healthStepsData
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
