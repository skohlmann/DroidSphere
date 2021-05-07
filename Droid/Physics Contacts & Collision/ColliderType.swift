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
import Combine

struct ColliderType: Hashable, CustomDebugStringConvertible {
    
    // Dictionary to specify which ColliderTypes should be notified of contacts with other ColliderTypes
    static var requestedContactNotifications = [ColliderType: [ColliderType]]()

    // Dictionary of which ColliderTypes should collide with other ColliderTypes.
    static var definedCollisions = [ColliderType: [ColliderType]]()

    let rawValue: Int

    static var Obstacle: ColliderType { return self.init(rawValue: 1 << 0) }
    static var Player: ColliderType   { return self.init(rawValue: 1 << 1) }
    static var Enemy: ColliderType    { return self.init(rawValue: 1 << 2) }
    static var Lift: ColliderType     { return self.init(rawValue: 1 << 3) }
    static var Shot: ColliderType     { return self.init(rawValue: 1 << 4) }

    // SceneeKit convenience
    var categoryMask: Int {
        return rawValue
    }

    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }

    // CustomDebugStringConvertible
    var debugDescription: String {
        switch self.rawValue {
            case ColliderType.Obstacle.rawValue:
                return "ColliderType.Obstacle"
                
            case ColliderType.Player.rawValue:
                return "ColliderType.Player"
            
            case ColliderType.Enemy.rawValue:
                return "ColliderType.Enemy"
                
        case ColliderType.Lift.rawValue:
            return "ColliderType.Lift"
        
        default:
                return "UnknownColliderType(\(self.rawValue))"
        }
    }
    
    // Value that can be assigned to a SCNPhysicsBody.collisionMask
    var collisionMask: Int {
        // Combine all of the collision requests for this type using a bitwise or.
        return ColliderType.definedCollisions[self]?
            .map {value -> Int in value.rawValue}
            .reduce(0, {preValue, newValue in preValue | newValue }) ?? 0
    }
    
    // Value that can be assigned to a SCNPhysicsBody.contactMask
    var contactMask: Int {
        // Combine all of the contact notification requests for this type using a bitwise or.
        return  ColliderType.requestedContactNotifications[self]?
            .map {value -> Int in value.rawValue}
            .reduce(0, {preValue, newValue in preValue | newValue }) ?? 0
    }


    // `true` if the `ContactNotifiableType` associated with this `ColliderType` should be
    // notified of contact with the passed `ColliderType`.
    func notifyOnContactWithColliderType(colliderType: ColliderType) -> Bool {
        if let requestedContacts = ColliderType.requestedContactNotifications[self] {
            return requestedContacts.contains(colliderType)
        }
        
        return false
    }
}
