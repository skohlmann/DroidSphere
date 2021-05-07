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

import SceneKit
import Foundation
import GameplayKit
import GameplayKit.SceneKit_Additions

class Enemy : BaseEntity, ContactNotifiableType {
    
    var playerNode : SCNNode
    
    init(playerNode : SCNNode) {
        self.playerNode = playerNode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    class func loadSharedAssets() {
        ColliderType.definedCollisions[.Enemy] = [
            .Obstacle,
            .Player,
            .Enemy,
            .Lift,
            .Shot
        ]
        
        ColliderType.requestedContactNotifications[.Enemy] = [
            .Obstacle,
            .Player,
            .Enemy,
            .Lift,
            .Shot
        ]
    }

    func contactWithEntityDidBegin(entity: BaseEntity) {}

    func contactWithEntityDidEnd(entity: BaseEntity) {}
    
}

