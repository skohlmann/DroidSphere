//
//  Vector+Point.swift
//  Droid
//
//  Created by Sascha Kohlmann on 26.04.21.
//

import CoreGraphics

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
