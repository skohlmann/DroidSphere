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

import CoreGraphics

let rad_to_deg : Double = 180.0 / .pi
let deg_to_rad : Double = .pi / 180.0

@inline(__always) func radians(_ degrees : Double) -> Double {
    return degrees * deg_to_rad
}

@inline(__always) func degrees(_ radians : Double) -> Double {
    return radians * rad_to_deg
}

@inline(__always) func radians(_ degrees : Float) -> Float {
    return degrees * Float(deg_to_rad)
}

@inline(__always) func degrees(_ radians : Float) -> Float {
    return radians * Float(rad_to_deg)
}

@inline(__always) func radians(_ degrees : CGFloat) -> CGFloat {
    return degrees * CGFloat(deg_to_rad)
}

@inline(__always) func degrees(_ radians : CGFloat) -> CGFloat {
    return radians * CGFloat(rad_to_deg)
}

extension CGPoint {
    
    func rotate(radians: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * cos(radians) - self.y * sin(radians), y: self.x * sin(radians) + self.y * cos(radians))
    }

    func rotate(degrees: CGFloat) -> CGPoint {
        return rotate(radians: radians(degrees))
    }
}

extension CGVector {
    
    func rotate(radians: CGFloat) -> CGVector {
        return CGVector(dx: self.dx * cos(radians) - self.dy * sin(radians), dy: self.dx * sin(radians) + self.dy * cos(radians))
    }
    func rotate(degrees: CGFloat) -> CGVector {
        return rotate(radians: radians(degrees))
    }
}
