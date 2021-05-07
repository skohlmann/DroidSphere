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

protocol BaseEntityDelegate: AnyObject {
    func entity(_ entity: GKEntity, didAddComponent component:     GKComponent)
    func entity(_ entity: GKEntity, willRemoveComponent component: GKComponent)
    
    @discardableResult
    func entity(_ entity: GKEntity, didSpawn spawnedEntity: GKEntity) -> Bool
    
    func entityDidRequestRemoval(_ entity: GKEntity)
}


class BaseEntity : GKEntity {
 
    var name : String?

    weak var delegate: BaseEntityDelegate? // CHECK: Should this be weak?

    init(name: String? = nil, components: [GKComponent] = []) {
        self.name = name
        super.init()
        
        for component in components {
            self.addComponent(component)
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        for component in self.components {
            guard let updateable = component as? UpdatablePerFrame else {continue}
            updateable.update(deltaTime: seconds)
        }
    }

    init(node: SCNNode, components: [GKComponent] = []) {
        self.name = node.name
        super.init()
        
        self.addComponent(NodeComponent(node: node))
        
        for component in components {
            self.addComponent(component)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addComponent(_ component: GKComponent) {
        component.entity?.removeComponent(ofType: type(of: component))
        if  let existingComponent = self.component(ofType: type(of: component)) {
            if  existingComponent !== component {
                self.removeComponent(ofType: type(of: existingComponent))
            }
        }
        
        super.addComponent(component)
        delegate?.entity(self, didAddComponent: component)
    }
    
    func removeFromDelegate() {
        self.delegate?.entityDidRequestRemoval(self)
    }

    deinit {
        for component in self.components {
            self.removeComponent(ofType: type(of: component))
        }
    }
}
