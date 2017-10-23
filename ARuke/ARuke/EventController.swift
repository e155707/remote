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
        Node?.name = "takarabako1"
        
        let scene2 = SCNScene(named: "art.scnassets/tresure/takarabako.dae")!
        let Node2 = scene2.rootNode.childNode(withName: "takarabako", recursively: true)
        
        Node2?.scale = SCNVector3(0.001, 0.001, 0.001)
        Node2?.position = SCNVector3(0.05, 0, -0.1)
        Node2?.name = "takarabako2"
        
        let scene3 = SCNScene(named: "art.scnassets/tresure/takarabako.dae")!
        let Node3 = scene3.rootNode.childNode(withName: "takarabako", recursively: true)
        
        Node3?.scale = SCNVector3(0.001, 0.001, 0.001)
        Node3?.position = SCNVector3(0.1, 0, -0.1)
        Node3?.name = "takarabako3"
        
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
                if(name == "takarabako1"){
                    sceneView.scene.rootNode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
                    let scene4 = SCNScene(named: "art.scnassets/itemx2.dae")!
                    let Node4 = scene4.rootNode.childNode(withName: "Text", recursively: true)
                    Node4?.scale = SCNVector3(0.01, 0.01, 0.01)
                    Node4?.position = SCNVector3(0, 0, -0.1)
                    Node4?.name = "x2"
                    
                    sceneView.scene.rootNode.addChildNode(Node4!)
                    
                    sceneView.scene.rootNode.ctrlAnimationOfAllChildren(do_play: false)
                    
                }else if(name == "takarabako2"){
                    sceneView.scene.rootNode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
                }else if(name == "takarabako3"){
                    sceneView.scene.rootNode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
                }else{
                    
                }
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



extension SCNNode {
    
    //アニメーションの実行，停止をboolで指定できるように
    func ctrlAnimation(forKey: String, play:Bool)
    {
        if let anim = animationPlayer(forKey: forKey) {
            if (play){
                anim.play()
            }else{
                anim.stop(withBlendOutDuration: 1.0)
            }
        }
    }
    
    //自分と子ノードのすべてのアニメーションをコントロールするコンビニエンス関数
    func ctrlAnimationOfAllChildren(do_play:Bool, anim_id:String = "")
    {
        for child in childNodes {
            child.ctrlAnimationOfAllChildren(do_play:do_play, anim_id:anim_id)
        }
        
        //anim_idが空文字列の場合，nodeの最初のアニメーションidを取得する
        if anim_id == "" && animationKeys.count > 0 {
            for key in animationKeys {
                ctrlAnimation(forKey: key, play:do_play)
            }
        }else {
            ctrlAnimation(forKey: anim_id, play: do_play)
        }
        
        
    }
    
    //自分と子ノードに設定されているすべてのアニメーションのkey(識別子)をprintする
    func printAllAnimationKeys ()
    {
        for child in childNodes {
            child.printAllAnimationKeys()
        }
        
        let node_name:String
        node_name = (name != nil) ? name! : "no name"
        
        print ( node_name, animationKeys)
    }
}
