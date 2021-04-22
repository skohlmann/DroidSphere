//
//  OverlayScene.swift
//  Droid
//
//  Created by Sascha Kohlmann on 19.04.21.
//

import Foundation
import SpriteKit
import SceneKit

let debug = true

class HUD : SKScene {
    
    var coordinateLabel : SKLabelNode!
    var overView : GameViewController
    var joystick : Joystick

    init(size: CGSize, scene : GameViewController) {
        
        if debug {
            print("Size: \(size)")
        }
        
        self.overView = scene
        self.joystick = Joystick(name: "left joystick", firstInputIn: Circle(at: CGPoint(x: 0, y: 0), with: size.width / 2))
        self.joystick.position.x = 100
        self.joystick.position.y = 140
        super.init(size: size)

        self.coordinateLabel = SKLabelNode(text: "")
        self.coordinateLabel.horizontalAlignmentMode = .left
        self.coordinateLabel.fontSize = 15
        self.coordinateLabel.fontColor = .black
        self.coordinateLabel.fontName = "AvenirNext-Bold"
        self.coordinateLabel.position = CGPoint(x: 20, y: self.size.height - 20)
        self.addChild(self.coordinateLabel)
        self.addChild(self.joystick)
        
        if debug {
            let inputCircle = SKShapeNode(circleOfRadius: Circle(at: CGPoint(x: 0, y: size.height), with: size.width / 2).radius)
            inputCircle.fillColor = .clear
            inputCircle.strokeColor = .lightGray
            inputCircle.position.x = Circle(at: CGPoint(x: 0, y: 0), with: size.width / 2).position.x
            inputCircle.position.y = Circle(at: CGPoint(x: 0, y: 0), with: size.width / 2).position.y
            self.addChild(inputCircle)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.onTouchesBegan(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.onTouchesMoved(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.onTouchesCancelled(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.onTouchesEnded(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    fileprivate func updateCoordinates(_ touches : Set<UITouch>) {
        self.coordinateLabel.text =  "Coordinates - current: x=\(Int((touches.first?.location(in: self.joystick).x)!)) · y=\(Int((touches.first?.location(in: self.joystick).y)!)) - previous: x=\(Int((touches.first?.previousLocation(in: self).x)!)) · y=\(Int((touches.first?.previousLocation(in: self).y)!))"
    }
}

class Joystick : SKNode {
    
    let firstInputCircle : Circle
    
    let joystickMaxMove = CGFloat(30)
    let joystickMininumMoveDistance : CGFloat = 2

    var joystickActive = false
    var joystickMoved = false

    var joystickInner : SKShapeNode!
    var joystickOuter : SKShapeNode!
    
    var beganPosition : CGPoint!
    var beganTime : TimeInterval!
    var moveStarted = false
    var distanceTolerance : CGFloat!

    init(name : String = "Joystick", firstInputIn : Circle) {
        self.joystickInner = SKShapeNode(circleOfRadius: 20)
        self.joystickInner.fillColor = .red
        self.joystickInner.strokeColor = .orange
        self.joystickInner.alpha = 20

        self.joystickOuter = SKShapeNode(circleOfRadius: 20 + joystickMaxMove)
        self.joystickOuter.fillColor = .clear
        self.joystickOuter.strokeColor = .red
        
        self.firstInputCircle = firstInputIn

        super.init()
        self.name = name
        self.addChild(self.joystickInner)
        self.addChild(self.joystickOuter)
    }
    
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchSelfTouch(touches, state: "began", for: scene) else {return}
        print("GO")

        self.beganTime = myTouch.timestamp
        self.beganPosition = self.position
        self.joystickInner.glowWidth = 1.0
        self.joystickOuter.glowWidth = 2.0
        self.distanceTolerance = myTouch.majorRadiusTolerance > self.joystickMininumMoveDistance ? myTouch.majorRadiusTolerance : self.joystickMininumMoveDistance

        self.position = calculateNewPosition(start: self.position, withDifference: myTouch.location(in: self))
    }
    
    @inline(__always) private func calculateNewPosition(start : CGPoint, withDifference diff : CGPoint) -> CGPoint {
        return start + diff
    }
    
    private func fetchSelfTouch(_ touches: Set<UITouch>, state: String, for scene : SKScene) -> UITouch! {
        for touch in touches {
            if debug {
                print("\(state) - my location: \(self.position)")
                print("\(state) - my inner location: \(self.joystickInner.position)")
                print("\(state) - location nil: \(touch.location(in: nil))")
                print("\(state) - location scene: \(touch.location(in: scene))")
                print("\(state) - location self: \(touch.location(in: self))")
                print("\(state) - previus location nil: \(touch.previousLocation(in: nil))")
                print("\(state) - previus location scene: \(touch.previousLocation(in: scene))")
                print("\(state) - previus location self: \(touch.previousLocation(in: self))")
                print("\(state) - radius: \(touch.majorRadius)")
                print("\(state) - radius tolerance: \(touch.majorRadiusTolerance)")
                print("\(state) - tap count: \(touch.tapCount)")
                print("\(state) - timestamp: \(touch.timestamp)")
                print("-----")
            }
            if isPositionIn(circle : self.firstInputCircle, withPosition: touch.location(in: scene)) {
                print("\(state) - return touch")
                return touch
            }
        }
        print("\(state) - return nil")
        return nil
    }
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchSelfTouch(touches, state: "moved", for: scene) else {return}
        
        print("Has moved - self location: \(myTouch.location(in: scene))")
        print("Has moved - from position: \(self.position)")
    }
    
    func onTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
    }
    
    func onTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        self.joystickInner.glowWidth = 0
        self.joystickOuter.glowWidth = 0
        self.moveStarted = false
        if self.beganPosition != nil {
            self.position = self.beganPosition
            self.beganPosition = nil
            self.beganTime = nil
        }
    }
    
    private func isPositionIn(circle: Circle, withPosition position : CGPoint) -> Bool {
        var xOf = position.x - circle.position.x
        xOf *= xOf
        var yOf = position.y - circle.position.y
        yOf *= yOf
        
        let length = sqrt(xOf + yOf)
        if debug {
            print("isIn - withPosition \(position)")
            print("isIn - ofCenter \(circle.position)")
            print("isIn - andRadius \(circle.radius)")
            print("isIn - length \(length)")
            print("isIn: \(length < circle.radius)")
        }
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

fileprivate extension CGPoint {
    
    @inline(__always) static func +=(lhs:inout CGPoint, rhs:CGPoint) {
        lhs.x = lhs.x + rhs.x
        lhs.y = lhs.y + rhs.y
    }
    
    @inline(__always) static func +(lhs: CGPoint, rhs:CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    @inline(__always) static func -=(lhs:inout CGPoint, rhs:CGPoint) {
        lhs.x = lhs.x - rhs.x
        lhs.y = lhs.y - rhs.y
    }
    
    @inline(__always) static func -(lhs: CGPoint, rhs:CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
