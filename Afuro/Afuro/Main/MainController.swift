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

class MainController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet var ARView: ARSCNView!
    //var ARView:ARSCNView?
    // ボタンを追加
    //@IBOutlet var afuroView: UIView!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var downButton: UIButton!
    
    enum ButtonTag: Int {
        case Right = 1
        case Left = 2
        case Up = 3
        case Down = 4
    }
    
    let moveAmount:Float = 1;

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
    
        afuroNode.position = SCNVector3(0,0,-1)
        ARView.scene.rootNode.addChildNode(afuroNode)
        
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
