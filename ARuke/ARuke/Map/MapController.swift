//
//  MapController.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/10/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import GoogleMaps
import UserNotifications

class MapController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    
    let locationManager = CLLocationManager()
    let scoreManager = ScoreManager()
    let mapCheckpoint = MapCheckpoint()
    
    // エレメントの数
    let elmentNum = 10
    
    // エレメントを選択した時に必要な変数群
    var selectElementWindow: UIWindow!
    var selectElementButton = UIButton()
    let initWaitTime = 5.0 + 1.0;
    var waitTime = 0.0;
    var waitTimeLabel = UILabel()
    
    
    var checkpoints:[CLLocation] = []
    
    @IBOutlet var mapView: GMSMapView!
    
    var selectElementPos = CLLocation()
    var isGetCheckpoint = false

    let cameraZoomLevel:Float = 17
    
    /** override vieDidLoad()
     * Viewの初期化,locationManagerの初期化. GoogleMapをMap.storyboardに表示する.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        initManager()
        setLocateManager()
        //let arukeTimeController = ARukeTimeController()
        //arukeTimeController.startAttackTimer(1)
    }
    
    func initManager(){
        mapCheckpoint.mapView = mapView
    }
    
    // mapViewの初期化. 最初は琉球大学を写すよう指定
    func initMapView(){

        // GoogleMapの初期化
        //getInitDummyCamera()
        self.mapView.delegate = self
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
        
        // 地形の起伏と道路を表示するマップ
        self.mapView.mapType = GMSMapViewType.terrain
        
    }
    
    func getInitDummyCamera(){
        // WGS84の座標系でカメラを設定. latitude: 緯度, longitude: 経度
        // WGS84の座標系での琉球大学の位置(緯度, 経度)
        let ryukyuLatitude = 26.253726
        let ryukyuLongitude = 127.766949
        let camera = GMSCameraPosition.camera(withLatitude: ryukyuLatitude, longitude: ryukyuLongitude, zoom: cameraZoomLevel)
        self.mapView.camera = camera
    }
    
    // 位置情報の設定
    func setLocateManager(){
        
        // 現在位置情報の精度, 誤差を決定. 以下の様なものがある
        // - kCLLocationAccuracyBestForNavigation ナビゲーションに最適な値
        // - kCLLocationAccuracyBest 最高精度(iOS,macOSのデフォルト値)
        // - kCLLocationAccuracyNearestTenMeters 10m
        // - kCLLocationAccuracyHundredMeters 100m（watchOSのデフォルト値）
        // - kCLLocationAccuracyKilometer 1Km
        // - kCLLocationAccuracyThreeKilometers 3Km
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 現在位置からどれぐらい動いたら更新するか. 単位はm
        locationManager.distanceFilter = 1
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    
    // flagがtrueの場合, 自分の位置を表示. 役割をわかりやすくするために関数化しただけ.
    func myLocationMarker(_ flag: Bool){
        mapView.isMyLocationEnabled = flag
    }
    
    // マーカーをタップした時に呼び出される関数.
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        createSelectElementWindow(marker)
        return true
    }
    
    // マーカーをタップした時に, そのマーカーに行くのか選択できる.
    func createSelectElementWindow(_ marker:GMSMarker){
        selectElementWindow = UIWindow()
        // 背景を黒に設定する.
        selectElementWindow.backgroundColor = UIColor.black
        
        selectElementWindow.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        selectElementWindow.alpha = 0.8
        
        // myWindowをkeyWindowにする.
        selectElementWindow.makeKey()
        
        // windowを表示する.
        self.selectElementWindow.makeKeyAndVisible()
        
        let tapSelectElementWindowGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapSelectElementWindow))
        
        selectElementWindow.addGestureRecognizer(tapSelectElementWindowGesture)
        
        // そのエレメントに行くか選択できるボタンを作成する.
        selectElementButton.frame = CGRect(x: self.view.bounds.width/2-self.view.bounds.width/4, y: self.view.bounds.width/2-self.view.bounds.width/4, width: self.view.bounds.width/2, height: self.view.bounds.height/2)
        selectElementButton.backgroundColor = UIColor.white
        selectElementButton.setTitle("\(marker.snippet ?? "不明なエレメント")に行く.", for: .normal)
        selectElementButton.setTitleColor(UIColor.black, for: .normal)
        selectElementButton.layer.masksToBounds = true
        selectElementButton.layer.cornerRadius = 20.0
        selectElementButton.addTarget(self, action: #selector(self.onClickSelectElementButton), for: .touchUpInside)
        self.selectElementWindow.addSubview(selectElementButton)
        
    }
    
    // selectElementWindowで, ボタン以外の場所をタップしたら元の画面に戻る.
    @objc func tapSelectElementWindow(){
        selectElementWindow = nil
    
    }
    
    // 行くelementが決まりボタンを押すと, 覚える時間が与えられる.
    @objc func onClickSelectElementButton(){
        selectElementWindow = nil
        // 何秒でマップを覚えさせるか
        waitTime = initWaitTime;
        // 何秒ごとに通知するか.
        let intervalTime = 1
        
        var timer = Timer()
        
        // waitTime秒後に実行したい処理
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {

            timer.invalidate()
            
            self.waitTime = self.initWaitTime;
            
            self.waitTimeLabel.removeFromSuperview()
            self.waitTimeLabel = UILabel()

            // 画面遷移
            print("画面遷移!")
            self.fromMaptoWalking()
        }
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(intervalTime),
                                     target: self,
                                     selector:#selector(self.changeWaitTimeLabel(_:)),
                                     userInfo: intervalTime,repeats: true)
    
    }
    
    // 後何秒覚える時間があるか表示
    @objc func changeWaitTimeLabel(_ timer: Timer!){
        
        waitTime -= timer.timeInterval
        waitTimeLabel.text = "あと\(waitTime + 1)秒で行先を覚えてね."
        waitTimeLabel.sizeToFit()
        waitTimeLabel.center = self.view.center
        waitTimeLabel.textColor = UIColor.black
        self.view.addSubview(waitTimeLabel)
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
            myLocationMarker(true)
            
            break
            
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            //alertMessage(message: "このアプリは常に位置情報が必要です.")
            myLocationMarker(true)
            locationManager.requestAlwaysAuthorization()
            // 位置情報取得の開始処理
            break
        
        }
    }
    
    
    
    // 位置情報がlocationManager.distanceFilterの値分更新された時に呼び出されるメソッド.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: cameraZoomLevel)
        self.mapView.camera = camera
        
        if !isGetCheckpoint {
            checkpoints = mapCheckpoint.getRandomCheckpoints(location, 10, 0.005)
            mapCheckpoint.drawCheckpointMarker(checkpoints)
            isGetCheckpoint = true
        }
        
        
        
        /*
        guard
            let goal = checkpoints.first else {
                checkpoints = mapCheckpoint.getRandomDummyCheckpoint()
                return
            }
 
        let locationDistance = location.distance(from: oldLocation)
        
        if mapCheckpoint.isCheckpointArrive(location, goal){
            // チェックポイントに着いたら通知をする.
            //notification()
            // 遷移
            self.fromMaptoEventCotroller()
            
        }else{

            scoreManager.setScore(locationDistance)
            oldLocation = location
        }*/
    }
    
    
    func notification() {
        
        print("scheduled notification")
        /*
        //let coordinate = mapRouteManager.dummyCheckpoint.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: 37.332331,longitude: -122.031219)
        let radius = 100.0
        let identifier = "arrived"
        
        let content = UNMutableNotificationContent()
        content.title = "ARukeより通知"
        content.body = "イベントが発生!!"
        content.sound = UNNotificationSound.default()
        
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: identifier)

        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let locationRequest = UNNotificationRequest(identifier: identifier,
                                                    content: content,
                                                    trigger: locationTrigger)
        UNUserNotificationCenter.current().add(locationRequest, withCompletionHandler: nil)
        */
        let content = UNMutableNotificationContent()
        content.title = "ARukeより通知"
        content.body = "イベントが発生!!"
        content.sound = UNNotificationSound.default()
        
        // 1秒後に発火
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "oneSecond",
                                            content: content,
                                            trigger: trigger)
        
        // ローカル通知予約
        UNUserNotificationCenter.current().add(request, withCompletionHandler:nil)
        
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
