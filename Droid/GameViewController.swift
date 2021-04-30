//  Droid Sphere is a work in progress game. May be never finished.
//  Copyright (C) 2021 Sascha Kohlmann
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
    var droid : SCNNode!
    var droidRotating = false
    
    var overlayScene : HUD!
    var coordinateLabel : SKLabelNode!

    var spawnTime : TimeInterval = 0
    
    var tappedObserver : NSObjectProtocol!
    var movedObserver : NSObjectProtocol!
    var moveStoppedObserver : NSObjectProtocol!
    var lastMovedMillis = Date().millisecondsSince1970
    var millisBetweenPossibleMoveChange : Int64 = 33
    var lastContactNode : SCNNode!

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
            if self.droid != nil && !self.droidRotating {
                let action = SCNAction.rotateBy(x: 2.0, y: 0.0, z: 2.0, duration: 1)
                self.droid.runAction(SCNAction.repeatForever(action), forKey: "rotate")
                self.droidRotating = true
            } else if self.droid != nil && self.droidRotating {
                self.droid.removeAction(forKey: "rotate")
                self.droidRotating = false
            }
        }

        self.movedObserver = NotificationCenter.default.addObserver(forName: self.movedName, object: nil, queue: nil) { notification in
            if self.droid != nil {
                let currentMillis = Date().millisecondsSince1970
                if currentMillis < self.millisBetweenPossibleMoveChange + self.lastMovedMillis {
                    return
                }
                self.lastMovedMillis = currentMillis
                guard let direction = notification.object as? Direction else {fatalError("move notification not of type Direction")}
                let directionVector = direction.direction.rotate(degrees: -45)
                let velocity = map(direction.velocity, tarlow: 0.03, tarhi: 0.3)
                let velocityVector = directionVector * velocity
                let moveBox = SCNAction.moveBy(x: velocityVector.dx, y: 0, z: -velocityVector.dy, duration: 0.03)
                self.droid.runAction(SCNAction.repeatForever(moveBox), forKey: "move")
                self.cameraNode.runAction(SCNAction.repeatForever(moveBox), forKey: "move")

            }
        }

        self.moveStoppedObserver = NotificationCenter.default.addObserver(forName: self.moveStoppedName, object: nil, queue: nil) { notification in
            if self.droid != nil {
                self.droid.removeAction(forKey: "move")
                self.cameraNode.removeAction(forKey: "move")
            }
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
        self.scnView.antialiasingMode = .none

    }

    func setupNodes() {
        self.cameraNode = self.scnScene.rootNode.childNode(withName: "OrthogonalCamera", recursively: true)
        self.droid = loadBaseDroid()
        self.droid.position.x = 0
        self.droid.position.y = 1
        self.droid.position.z = 0
        self.scnScene.rootNode.addChildNode(self.droid)
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
    
    func loadBaseDroid() -> SCNNode {
        let droidUrl = Bundle.main.url(forResource: "BaseDroid", withExtension: "usdz", subdirectory: "Droid.scnassets/Droids")!
        let droidNode = SCNReferenceNode(url: droidUrl)!
        droidNode.load()
        droidNode.name = "BaseDroid"
        let physicalBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: SCNSphere(radius: 1.0)))
        physicalBody.isAffectedByGravity = false
        physicalBody.mass = 1
        physicalBody.collisionBitMask = -1
        physicalBody.categoryBitMask = 1
        droidNode.physicsBody = physicalBody
        
        return droidNode
    }
}

extension GameViewController : SCNSceneRendererDelegate {

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
}

extension GameViewController : SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode : SCNNode!
        print("Contact - nodeA: \(contact.nodeA)")
        print("Contact - nodeA: \(contact.nodeB)")
        if contact.nodeA.name == "Collidable" {
            print("Contact")
        }
        
    }
}
