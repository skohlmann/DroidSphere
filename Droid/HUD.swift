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
        self.overView = scene
        self.joystick = Joystick(name: "left joystick", firstInputRadius: (size.width / 2) - 100)
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
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.touchesBegan(touches, with: event)
        updateCoordinates(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.touchesMoved(touches, with: event)
        updateCoordinates(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.touchesCancelled(touches, with: event)
        updateCoordinates(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.touchesEnded(touches, with: event)
        updateCoordinates(touches)
    }
    
    fileprivate func updateCoordinates(_ touches : Set<UITouch>) {
        self.coordinateLabel.text =  "Coordinates - current: x=\(Int((touches.first?.location(in: self.joystick).x)!)) · y=\(Int((touches.first?.location(in: self.joystick).y)!)) - previous: x=\(Int((touches.first?.previousLocation(in: self).x)!)) · y=\(Int((touches.first?.previousLocation(in: self).y)!))"
    }
}

class Joystick : SKNode {
    
    let firstInputRadius : CGFloat
    
    let joystickMaxMove = CGFloat(30)
    let joystickMininumMoveDistance = 2

    var joystickActive = false
    var joystickMoved = false

    var joystickInner : SKShapeNode!
    var joystickOuter : SKShapeNode!
    var debugOuter : SKShapeNode!
    
    var startPosition : CGPoint!

    init(name : String = "Joystick", firstInputRadius : CGFloat = 200) {
        self.joystickInner = SKShapeNode(circleOfRadius: 20)
        self.joystickInner.fillColor = .red
        self.joystickInner.strokeColor = .orange
        self.joystickInner.alpha = 20

        self.joystickOuter = SKShapeNode(circleOfRadius: 20 + joystickMaxMove)
        self.joystickOuter.fillColor = .clear
        self.joystickOuter.strokeColor = .red
        
        self.debugOuter = SKShapeNode(circleOfRadius: firstInputRadius)
        self.debugOuter.fillColor = .clear
        self.debugOuter.strokeColor = .lightGray
        
        self.firstInputRadius = firstInputRadius

        super.init()
        self.name = name
        self.addChild(self.joystickInner)
        self.addChild(self.joystickOuter)
        if debug {
            self.addChild(self.debugOuter)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selfPosistion = forSelfPosition(touches, state: "began") else {return}
        self.joystickInner.glowWidth = 1.0
        self.joystickOuter.glowWidth = 2.0
        self.startPosition = self.position
    }
    
    private func forSelfPosition(_ touches: Set<UITouch>, state: String) -> CGPoint! {
        for touch in touches {
            if debug {
                print("\(state) - location: \(touch.location(in: nil))")
                print("\(state) - location: \(touch.location(in: self))")
                print("\(state) - radius: \(touch.majorRadius)")
                print("\(state) - radius tolerance: \(touch.majorRadiusTolerance)")
                print("\(state) - tap count: \(touch.tapCount)")
                print("\(state) - timestamp: \(touch.timestamp)")
                print("\(state) - phase: \(touch.phase)")
                print("\(state) - type: \(touch.type)")
                print("-----")
            }
            if isIn(ofPosition: touch.location(in: self), from: self.position, withRadius: firstInputRadius) {
                return touch.location(in: self.inputView)
            }
        }
        return nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selfPosistion = forSelfPosition(touches, state: "moved") else {return}
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystickInner.glowWidth = 0
        self.joystickOuter.glowWidth = 0
        self.position = self.startPosition
    }
    
    private func isIn(ofPosition position : CGPoint, from : CGPoint, withRadius radius : CGFloat) -> Bool {
        var xOf = position.x - from.x
        xOf *= xOf
        var yOf = position.y - from.y
        yOf *= yOf
        
        let length = sqrt(xOf + yOf)
        if debug {
            print("isIn - position \(position)")
            print("isIn - from \(from)")
            print("isIn - radius \(radius)")
            print("isIn - length \(length)")
            print("isIn: \(length < radius)")
        }
        return length < radius
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
