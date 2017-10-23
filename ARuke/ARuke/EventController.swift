//
//  EventController.swift
//  ARuke
//
//  Created by e155707 on 2017/10/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class EventController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/tresure/takarabako.dae")!
        let Node = scene.rootNode.childNode(withName: "takarabako", recursively: true)
        
        Node?.scale = SCNVector3(0.001, 0.001, 0.001)
        Node?.position = SCNVector3(0, 0, -0.1)
        
        let scene2 = SCNScene(named: "art.scnassets/tresure/takarabako.dae")!
        let Node2 = scene2.rootNode.childNode(withName: "takarabako", recursively: true)
        
        Node2?.scale = SCNVector3(0.001, 0.001, 0.001)
        Node2?.position = SCNVector3(0.05, 0, -0.1)
        
        let scene3 = SCNScene(named: "art.scnassets/itemx2.dae")!
        let Node3 = scene3.rootNode.childNode(withName: "Text", recursively: true)
        
        Node3?.scale = SCNVector3(0.0001, 0.0001, 0.0001)
        Node3?.position = SCNVector3(0.1, 0, -0.1)
        
        //sceneView.pointOfView?.addChildNode(Node!)
        //sceneView.pointOfView?.addChildNode(Node2!)
        //sceneView.pointOfView?.addChildNode(Node3!)
        //Node?.position = SCNVector3(1,1,0)
        //Node2?.position = SCNVector3(2,1,0)
        //Node3?.position = SCNVector3(3,1,0)
        
        
        scene.rootNode.addChildNode(Node2!)
        scene.rootNode.addChildNode(Node3!)

        // Set the scene to the view
        sceneView.scene = scene
        
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(self.handleTap(sender:)))
        sceneView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let view = self.sceneView else { //scnViewが存在することを保証(同時にアンラップ)
            return
        }
        if sender.state == .ended { //タップし終えたか？
            
            //タップ位置を取得
            let loc = sender.location(in: self.sceneView)
            //３Dオブジェクトに対するヒットテスト（どのgeometryをタップしたか？）
            let results = view.hitTest(loc)
            
            //結果は配列で返る．一つ以上ヒットしており，かつヒットしたgeometryのノードに名前があれば実行する
            if let res = results.first, let name = res.node.name {
                print(name)
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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

