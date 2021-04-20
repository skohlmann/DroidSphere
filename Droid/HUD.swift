//
//  OverlayScene.swift
//  Droid
//
//  Created by Sascha Kohlmann on 19.04.21.
//

import Foundation
import SpriteKit
import SceneKit

class HUD : SKScene {
    
    var coordinateLabel : SKLabelNode!
    var overView : GameViewController
    var joystick : Joystick

    init(size: CGSize, scene : GameViewController) {
        self.overView = scene
        self.joystick = Joystick()
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
        updateCoordinates(touches)
        self.overView.onTouchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateCoordinates(touches)
        self.overView.onTouchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateCoordinates(touches)
        self.overView.onTouchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateCoordinates(touches)
        self.overView.onTouchesEnded(touches, with: event)
    }
    
    fileprivate func updateCoordinates(_ touches : Set<UITouch>) {
        self.coordinateLabel.text =  "Coordinates - current: x=\(Int((touches.first?.location(in: self).x)!)) · y=\(Int((touches.first?.location(in: self).y)!)) - previous: x=\(Int((touches.first?.previousLocation(in: self).x)!)) · y=\(Int((touches.first?.previousLocation(in: self).y)!))"
    }
}

class Joystick : SKNode {
    
    let joystickMaxMove = CGFloat(30)
    let joystickMininumMoveDistance = 2

    var joystickActive = false
    var joystickMoved = false

    var joystickInner : SKShapeNode!
    var joystickOuter : SKShapeNode!

    override init() {
        self.joystickInner = SKShapeNode(circleOfRadius: 20)
        self.joystickInner.fillColor = .red
        self.joystickInner.strokeColor = .orange
        self.joystickInner.alpha = 20

        self.joystickOuter = SKShapeNode(circleOfRadius: 20 + joystickMaxMove)
        self.joystickOuter.fillColor = .clear
        self.joystickOuter.strokeColor = .red

        super.init()
        self.addChild(self.joystickInner)
        self.addChild(self.joystickOuter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
