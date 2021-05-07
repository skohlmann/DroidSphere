//
//  Nameable.swift
//  Droid
//
//  Created by Sascha Kohlmann on 06.05.21.
//

import Foundation
import SceneKit

protocol Nameable {
    var name : String? { get }
}

extension BaseEntity : Nameable {}
extension SCNNode : Nameable {}
