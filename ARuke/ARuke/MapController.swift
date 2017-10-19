//
//  MapController.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/10/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import GoogleMaps


class MapConroller: UIViewController, CLLocationManagerDelegate {
    
    /** override loadView()
     * Viewの初期化. GoogleMapをMap.storyboardに表示する.
     */
    override func loadView() {
        
        // WGS84の座標系での琉球大学の位置(緯度, 経度)
        let latitude = 26.247582
        let longitude = 127.765142
        
        // WGS84の座標系でカメラを設定. latitude: 緯度, longitude: 経度
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.mapType = .terrain
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        
        // マーカーの場所を表示. WGS84の座標系. latitude: 緯度, longitude: 経度
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Ryuukyuu"
        marker.snippet = "Okinawa"
        marker.map = mapView
        
    }
    
    override func viewDidLoad() {
        

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
