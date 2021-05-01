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
import SceneKit

extension CGPoint {
    
    @inline(__always) static func +=(lhs:inout CGPoint, rhs:CGPoint) {
        lhs.x = lhs.x + rhs.x
        lhs.y = lhs.y + rhs.y
    }
    
    @inline(__always) static func +(lhs: CGPoint, rhs:CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    @inline(__always) static func -=(lhs:inout CGPoint, rhs:CGPoint) {
        lhs.x = lhs.x - rhs.x
        lhs.y = lhs.y - rhs.y
    }
    
    @inline(__always) static func -(lhs: CGPoint, rhs:CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    @inline(__always) static func *(lhs : CGPoint, rhs : CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    @inline(__always) static func *=(lhs:inout CGPoint, rhs : CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    @inline(__always) static func *=(lhs : CGFloat, rhs:inout CGPoint) -> CGPoint {
        return rhs * lhs
    }

    @inline(__always) static func /(lhs : CGPoint, rhs : CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    @inline(__always) static func /=(lhs:inout CGPoint, rhs : CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    @inline(__always) static func /=(lhs : CGFloat, rhs:inout CGPoint) -> CGPoint {
        return rhs / lhs
    }

    var magnitude : CGFloat {
        get {
            return sqrt(self.x * self.x + self.y * self.y)
        }
    }

    var normalized : CGPoint {
        get {
            let mag = magnitude
            return CGPoint(x: self.x / mag, y: self.y / mag)
        }
    }
    
    @inline(__always) func angle(_ other: CGPoint) -> CGFloat {
        return atan2(other.x - self.x, other.y - self.y)
    }

    @inline(__always) func dot(_ other: CGPoint) -> CGFloat {
        return self.x * other.x + self.y * other.y
    }

    @inline(__always) func distance(to other: CGPoint) -> CGFloat {
        var xOf = self.x - other.x
        xOf *= xOf
        var yOf = self.y - other.y
        yOf *= yOf
        
        return sqrt(xOf + yOf)
    }

    @inline(__always) func toCGVector() -> CGVector {
        return CGVector(dx: self.x, dy: self.y)
    }
    
    @inline(__always) func direction(from source : CGPoint) -> CGPoint {
        return self - source
    }
    @inline(__always) func direction(to target : CGPoint) -> CGPoint {
        return target - self
    }
}

extension CGVector {
    
    @inline(__always) static func +=(lhs:inout CGVector, rhs:CGVector) {
        lhs.dx = lhs.dx + rhs.dx
        lhs.dy = lhs.dy + rhs.dy
    }
    
    @inline(__always) static func +(lhs: CGVector, rhs:CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    @inline(__always) static func -=(lhs:inout CGVector, rhs:CGVector) {
        lhs.dx = lhs.dx - rhs.dx
        lhs.dy = lhs.dy - rhs.dy
    }
    
    @inline(__always) static func -(lhs: CGVector, rhs:CGVector) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    @inline(__always) static func *(lhs : CGVector, rhs : CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    @inline(__always) static func *=(lhs:inout CGVector, rhs : CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    @inline(__always) static func *=(lhs : CGFloat, rhs:inout CGVector) -> CGVector {
        return rhs * lhs
    }

    @inline(__always) static func /(lhs : CGVector, rhs : CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }

    @inline(__always) static func /=(lhs:inout CGVector, rhs : CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }

    @inline(__always) static func /=(lhs : CGFloat, rhs:inout CGVector) -> CGVector {
        return rhs / lhs
    }

    var magnitude : CGFloat {
        get {
            return sqrt(self.dx * self.dx + self.dy * self.dy)
        }
    }

    var normalized : CGVector {
        get {
            let mag = magnitude
            return CGVector(dx: self.dx / mag, dy: self.dy / mag)
        }
    }
    
    @inline(__always) func angle(_ other: CGVector) -> CGFloat {
        return atan2(other.dx - self.dx, other.dy - self.dy)
    }

    @inline(__always) func dot(_ other: CGVector) -> CGFloat {
        return self.dx * other.dx + self.dy * other.dy
    }

    @inline(__always) func distance(to other: CGVector) -> CGFloat {
        var xOf = self.dx - other.dx
        xOf *= xOf
        var yOf = self.dy - other.dy
        yOf *= yOf
        
        return sqrt(xOf + yOf)
    }
    
    @inline(__always) func toCGPoint() -> CGPoint {
        return CGPoint(x: self.dx, y: self.dy)
    }
}

extension SCNVector3 {
    
    @inline(__always) static func +=(lhs:inout SCNVector3, rhs:SCNVector3) {
        lhs.x = lhs.x + rhs.x
        lhs.y = lhs.y + rhs.y
        lhs.z = lhs.z + rhs.z
    }
    
    @inline(__always) static func +(lhs: SCNVector3, rhs:SCNVector3) -> SCNVector3 {
        return SCNVector3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
}
