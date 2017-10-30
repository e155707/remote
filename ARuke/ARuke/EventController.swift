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
    
    var hitx:Float = 0
    var hity:Float = 0
    var hitz:Float = 0
    
    var Opennode:SCNNode = SCNNode()
    
    var planes:[Plane] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
    
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(self.handleTap(sender:)))
        sceneView.addGestureRecognizer(tapGesture)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 平面を生成
        let plane = Plane(anchor: planeAnchor)
        
        Opennode = node
        
        let scene1 = SCNScene(named: "art.scnassets/tresure/takarabako.dae")!
        let scene2 = SCNScene(named: "art.scnassets/tresure/takarabako.dae")!
        let scene3 = SCNScene(named: "art.scnassets/tresure/takarabako.dae")!
        
        let Node1 = scene1.rootNode.childNode(withName: "takarabako", recursively: true)
        let Node2 = scene2.rootNode.childNode(withName: "takarabako", recursively: true)
        let Node3 = scene3.rootNode.childNode(withName: "takarabako", recursively: true)
        
        Node1?.scale = SCNVector3(0.005, 0.005, 0.005)
        Node2?.scale = SCNVector3(0.005, 0.005, 0.005)
        Node3?.scale = SCNVector3(0.005, 0.005, 0.005)
        
        Node1?.position = SCNVector3(planeAnchor.center.x - 0.5, 0, planeAnchor.center.z)
        Node2?.position = SCNVector3(planeAnchor.center.x ,      0, planeAnchor.center.z)
        Node3?.position = SCNVector3(planeAnchor.center.x + 0.5, 0, planeAnchor.center.z)
        
        hitx = planeAnchor.center.x
        hity = 0
        hitz = planeAnchor.center.z
        
        Node1?.name = "takarabako1"
        Node2?.name = "takarabako2"
        Node3?.name = "takarabako3"
        
        
        Opennode.addChildNode(Node1!)
        Opennode.addChildNode(Node2!)
        Opennode.addChildNode(Node3!)
        
        // ノードを追加
        Opennode.addChildNode(plane)
        
        // 管理用配列に追加
        planes.append(plane)
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
                if(name == "takarabako2"){
                    Opennode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
                    
                    let scene4 = SCNScene(named: "art.scnassets/itemx2.dae")!
                    let Node4 = scene4.rootNode.childNode(withName: "Text", recursively: true)
                    Node4?.scale = SCNVector3(0.1, 0.1, 0.1)
                    Node4?.position = SCNVector3(hitx,hity,hitz)
                    Node4?.name = "x2"
                    
                    Opennode.addChildNode(Node4!)
                    
                    Opennode.ctrlAnimationOfAllChildren(do_play: false)
                    
                }else if(name == "takarabako1"){
                    Opennode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
                }else if(name == "takarabako3"){
                    Opennode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
                }else{
                    let storyboard: UIStoryboard = UIStoryboard(name:"Map",bundle: nil)
                    let next = storyboard.instantiateViewController(withIdentifier: "Map") as! MapConroller
                    present(next as UIViewController, animated: true,completion: nil)
                    print("Map")
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
