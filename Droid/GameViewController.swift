//
//  GameViewController.swift
//  Sphere
//
//  Created by Sascha Kohlmann on 15.04.21.
//

import UIKit
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scnView : SCNView!
    var scnScene : SCNScene!
    
    var cameraNode : SCNNode!
    var box : SCNNode!
    
    var overlayScene : HUD!
    var coordinateLabel : SKLabelNode!

    var spawnTime : TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupNodes()
        setupSounds()
    }

    func setupScene() {
        self.scnView = (self.view as! SCNView)
        self.scnView.showsStatistics = true
        self.scnView.delegate = self

        self.overlayScene = HUD(size: self.scnView.bounds.size, scene: self)
        self.scnView.overlaySKScene = self.overlayScene

        self.scnScene = SCNScene(named: "Droid.scnassets/Scenes/Game.scn")
        self.scnView.scene = self.scnScene
    }
    
    func setupNodes() {
        self.cameraNode = self.scnScene.rootNode.childNode(withName: "OrthogonalCamera", recursively: true)
        self.box = self.scnScene.rootNode.childNode(withName: "Box", recursively: true)
    }
    
    func setupSounds() {

    }
        
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugUITouches(touches, caller: "touchesBegan")
    }
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugUITouches(touches, caller: "touchesMoved")
    }
    
    func onTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugUITouches(touches, caller: "touchesCancelled")
    }
    
    func onTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugUITouches(touches, caller: "touchesEnded")
    }
    
    fileprivate func debugUITouches(_ touches: Set<UITouch>, caller: String) {
        /*
        var count = 0
        for touch in touches {
            print("\(caller) (\(count)) - force: \(touch.force)")
            print("\(caller) (\(count)) - tapCount: \(touch.tapCount)")
            print("\(caller) (\(count)) - location: \(touch.location(in: self.scnView))")
            print("---------")
            count += 1
        }
        print("#########")
 */
    }
    
}

extension GameViewController : SCNSceneRendererDelegate {

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
}
