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
    
    let tappedName = Notification.Name("button1 tapped")
    let movedName = Notification.Name("stick1 moved")
    let moveStoppedName = Notification.Name("stick1 move stopped")

    var scnView : SCNView!
    var scnScene : SCNScene!
    
    var cameraNode : SCNNode!
    var box : SCNNode!
    var boxRotating = false
    
    var overlayScene : HUD!
    var coordinateLabel : SKLabelNode!

    var spawnTime : TimeInterval = 0
    
    var tappedObserver : NSObjectProtocol!
    var movedObserver : NSObjectProtocol!
    var moveStoppedObserver : NSObjectProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupNodes()
        setupSounds()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.tappedObserver != nil {
            NotificationCenter.default.removeObserver(self.tappedObserver!)
        }
        if self.movedObserver != nil {
            NotificationCenter.default.removeObserver(self.movedObserver!)
        }
        if self.moveStoppedObserver != nil {
            NotificationCenter.default.removeObserver(self.moveStoppedObserver!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tappedObserver = NotificationCenter.default.addObserver(forName: self.tappedName, object: nil, queue: nil) { notification in
            if self.box != nil && !self.boxRotating {
                let action = SCNAction.rotateBy(x: 0, y: 2.0, z: 2.0, duration: 1)
                self.box.runAction(SCNAction.repeatForever(action), forKey: "rotate")
                self.boxRotating = true
            } else if self.box != nil && self.boxRotating {
                self.box.removeAction(forKey: "rotate")
                self.boxRotating = false
            }
        }
        self.movedObserver = NotificationCenter.default.addObserver(forName: self.movedName, object: nil, queue: nil) { notification in
            if self.box != nil {
                guard let direction = notification.object as? Direction else {fatalError("move notification not CGVector")}
                print("direction: \(direction)")
            }
        }
        self.moveStoppedObserver = NotificationCenter.default.addObserver(forName: self.moveStoppedName, object: nil, queue: nil) { notification in
        }
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
