//
//  OverlayScene.swift
//  Droid
//
//  Created by Sascha Kohlmann on 19.04.21.
//

import Foundation
import SpriteKit
import SceneKit

class OverlayScene : SKScene {
    
    var coordinateLabel : SKLabelNode!
    var overView : GameViewController

    init(size: CGSize, scene : GameViewController) {
        self.overView = scene
        super.init(size: size)

        self.coordinateLabel = SKLabelNode(text: "")
        self.coordinateLabel.horizontalAlignmentMode = .left
        self.coordinateLabel.fontSize = 15
        self.coordinateLabel.fontColor = .black
        self.coordinateLabel.fontName = "AvenirNext-Bold"
        self.coordinateLabel.position = CGPoint(x: 20, y: self.size.height - 20)
        self.addChild(self.coordinateLabel)
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
        self.coordinateLabel.text =  "Coordinates: x=\(Int((touches.first?.location(in: self).x)!)) - y=\(Int((touches.first?.location(in: self).y)!))"
    }
}
