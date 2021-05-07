//
//  UpdatablePerFrame.swift
//  Droid
//
//  Created by Sascha Kohlmann on 06.05.21.
//

import Foundation

protocol UpdatablePerFrame {
    func update(deltaTime seconds: TimeInterval)
}

