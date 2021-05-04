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

import Foundation
import SpriteKit
import SceneKit

class HUD : SKScene {
    
    var coordinateLabel : SKLabelNode!
    var overView : GameViewController
    let gamepad : GamePad

    init(size: CGSize, scene : GameViewController) {
        
        self.overView = scene
        self.gamepad = GamePad(name: "left gamepad", firstInputIn: Circle(at: CGPoint(x: 0, y: 0), with: size.width / 2))
        self.gamepad.position.x = 100
        self.gamepad.position.y = 140
        self.gamepad.tapped = scene.tappedName
        self.gamepad.moved = scene.movedName
        self.gamepad.moveStopped = scene.moveStoppedName

        super.init(size: size)

        self.addChild(self.gamepad)

        if debug {
            self.coordinateLabel = SKLabelNode(text: "")
            self.coordinateLabel.horizontalAlignmentMode = .left
            self.coordinateLabel.fontSize = 15
            self.coordinateLabel.fontColor = .black
            self.coordinateLabel.fontName = "AvenirNext-Bold"
            self.coordinateLabel.position = CGPoint(x: 20, y: self.size.height - 20)
            self.name = "coordinate label"
            self.addChild(self.coordinateLabel)
        }
        
        if debug {
            let inputCircle = SKShapeNode(circleOfRadius: Circle(at: CGPoint(x: 0, y: size.height), with: size.width / 2).radius)
            inputCircle.fillColor = .clear
            inputCircle.strokeColor = .lightGray
            inputCircle.position.x = Circle(at: CGPoint(x: 0, y: 0), with: size.width / 2).position.x
            inputCircle.position.y = Circle(at: CGPoint(x: 0, y: 0), with: size.width / 2).position.y
            inputCircle.name = "input bound"
            self.addChild(inputCircle)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gamepad.onTouchesBegan(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gamepad.onTouchesMoved(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gamepad.onTouchesCancelled(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gamepad.onTouchesEnded(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    fileprivate func updateCoordinates(_ touches : Set<UITouch>) {
        if debug {
            self.coordinateLabel.text =  "Coordinates - current: x=\(Int((touches.first?.location(in: self.gamepad).x)!)) · y=\(Int((touches.first?.location(in: self.gamepad).y)!)) - previous: x=\(Int((touches.first?.previousLocation(in: self).x)!)) · y=\(Int((touches.first?.previousLocation(in: self).y)!))"
        }
    }
}

class GamePad : SKNode {
    
    let firstInputCircle : Circle
    
    let gamepadMaxMove = CGFloat(30)
    let gamepadMaxMoveBounds = CGFloat(30) - 4
    let gamepadMininumMoveDistance : CGFloat = 2

    var motionActive = false

    var gamepadInner : SKShapeNode!
    var gamepadOuter : SKShapeNode!
    
    var beganPosition : CGPoint!
    var beganTime : Int64
    var longPress = false
    var moveStarted = false
    var distanceTolerance : CGFloat!
    
    var tapped : Notification.Name!
    var moved : Notification.Name!
    var moveStopped : Notification.Name!
    
    init(name : String = "Joystick", firstInputIn : Circle) {
        self.beganTime = Date().millisecondsSince1970
        self.gamepadInner = SKShapeNode(circleOfRadius: 20)
        self.gamepadInner.fillColor = .white
        self.gamepadInner.strokeColor = .lightGray
        self.gamepadInner.alpha = 20

        self.gamepadOuter = SKShapeNode(circleOfRadius: 20 + gamepadMaxMove)
        self.gamepadOuter.fillColor = .clear
        self.gamepadOuter.strokeColor = .white
        
        self.firstInputCircle = firstInputIn

        super.init()
        self.name = name
        self.addChild(self.gamepadInner)
        self.addChild(self.gamepadOuter)
    }
    
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchMyTouch(touches, for: scene) else {return}
        if self.beganPosition == nil {
            self.beganPosition = self.position
        }
        self.distanceTolerance = myTouch.majorRadiusTolerance > self.gamepadMininumMoveDistance ? myTouch.majorRadiusTolerance : self.gamepadMininumMoveDistance
        self.beganTime = Date().millisecondsSince1970
        initLongTouchTimer(myTouch)
    }

    fileprivate func initLongTouchTimer(_ myTouch: UITouch) {
        Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(longPress(timer:)), userInfo: (beganTime: self.beganTime, event: myTouch), repeats: false)
    }
    
    @objc func longPress(timer : Timer) {
        guard let eventData = timer.userInfo as? (beganTime: Int64, event: UITouch) else {fatalError("long press value not of type (beganTime: Int64, event: UITouch)")}
        if eventData.beganTime == self.beganTime {
            self.longPress = true
            self.gamepadInner.glowWidth = 1.0
            self.gamepadOuter.glowWidth = 2.0

            self.position = calculateNewPosition(start: self.position, withDifference: eventData.event.location(in: self))
        }
    }

    @inline(__always) private func calculateNewPosition(start : CGPoint, withDifference diff : CGPoint) -> CGPoint {
        return start + diff
    }
    
    fileprivate func firstMoveEffective(_ distance: CGFloat) {
        if !self.motionActive {
            if distance >= self.distanceTolerance {
                self.motionActive = true
            }
        }
    }
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchMyTouch(touches, for: scene) else {return}
        let myScenePosition = myTouch.location(in: scene)
        let distance = self.position.distance(to: myScenePosition)
        
        firstMoveEffective(distance)
        
        if self.motionActive {
            let directionVector = self.position.direction(to: myScenePosition)
            if distance > self.gamepadMaxMoveBounds {
                let shiftFactor = 1 - self.gamepadMaxMoveBounds / distance
                let shiftVector = directionVector * shiftFactor
                self.position += shiftVector
            }
            self.gamepadInner.position = myTouch.location(in: self)
            if self.moved != nil {
                let velocity = map(distance <= self.gamepadMaxMoveBounds ? distance : self.gamepadMaxMoveBounds, vallow: 0, valhi: self.gamepadMaxMoveBounds, tarlow: 0, tarhi: 1)
                let normalized = directionVector.normalized
                let vector = CGVector(dx: normalized.x, dy: normalized.y)
                NotificationCenter.default.post(name: self.moved, object: Direction(direction: vector, velocity: velocity))
            }
        }
    }
    
    func onTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchMyTouch(touches, for: scene) else {return}
    }
    
    func onTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchMyTouch(touches, for: scene) else {return}
        self.beganTime = Date().millisecondsSince1970
        if !longPress && self.tapped != nil {
            NotificationCenter.default.post(name: self.tapped, object: myTouch.location(in: scene))
        }

        if self.longPress {
            self.gamepadInner.glowWidth = 0
            self.gamepadOuter.glowWidth = 0
            self.moveStarted = false
            self.motionActive = false
            if self.beganPosition != nil {
                self.position = self.beganPosition
                self.gamepadInner.position = CGPoint(x: 0, y: 0)
            }
            if self.moveStopped != nil {
                NotificationCenter.default.post(name: self.moveStopped, object: myTouch.location(in: scene))
            }
        }
        self.longPress = false
    }
    
    private func fetchMyTouch(_ touches: Set<UITouch>, for scene : SKScene) -> UITouch! {
        for touch in touches {
            let location = touch.location(in: scene)
            if !self.longPress && isPositionIn(circle : self.firstInputCircle, withPosition: location) {
                return touch
            }
            if isAround(location: self.position, withPosition: location) {
                return touch
            }
        }
        return nil
    }
    
    @inline(__always) private func isAround(location: CGPoint, withPosition position : CGPoint) -> Bool {
        let place = Circle(at: location, with: 80)
        return isPositionIn(circle: place, withPosition: position)
    }
    
    @inline(__always) private func isPositionIn(circle: Circle, withPosition position : CGPoint) -> Bool {
        let length = position.distance(to: CGPoint(x: circle.position.x, y: circle.position.y))
        return length < circle.radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Circle {
    var position : CGPoint
    var radius : CGFloat
    
    init(at position : CGPoint, with radius : CGFloat) {
        self.position = position
        self.radius = radius
    }
}
