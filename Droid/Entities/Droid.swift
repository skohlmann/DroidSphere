//
//  PlayerDroid.swift
//  Droid
//
//  Created by Sascha Kohlmann on 06.05.21.
//

import SceneKit
import Foundation
import GameplayKit
import GameplayKit.SceneKit_Additions

class Droid : BaseEntity {
    
    var playerNode : SCNNode
    
    init(playerNode : SCNNode) {
        self.playerNode = playerNode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    class func loadMiscellaneousAssets() {
        ColliderType.definedCollisions[.Player] = [
            .Player,
            .Enemy,
            .Obstacle,
            .Lift
        ]
    }
}
