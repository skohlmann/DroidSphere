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
import GameplayKit
import SceneKit

class NodeComponent : GKSCNNodeComponent {

    override init(node: SCNNode) {
        super.init(node: node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        if  let baseEntity = self.entity as? BaseEntity {
            if  self.node.name == nil && baseEntity.name != nil {
                self.node.name = baseEntity.name
            } else if baseEntity.name == nil && self.node.name != nil {
                baseEntity.name = self.node.name
            }
        }
        self.node.isPaused = false
    }
    
    override func willRemoveFromEntity() {
        super.node.removeAllActions()  // ?
    }
}
