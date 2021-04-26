//
//  OverlayScene.swift
//  Droid
//
//  Created by Sascha Kohlmann on 19.04.21.
//

import Foundation
import SpriteKit
import SceneKit

let debug = true

class HUD : SKScene {
    
    var coordinateLabel : SKLabelNode!
    var overView : GameViewController
    var joystick : Joystick

    init(size: CGSize, scene : GameViewController) {
        
        self.overView = scene
        self.joystick = Joystick(name: "left joystick", firstInputIn: Circle(at: CGPoint(x: 0, y: 0), with: size.width / 2))
        self.joystick.position.x = 100
        self.joystick.position.y = 140
        
        self.joystick.tapAt = {point in
            print("Tap Point: \(point)")
        }
        
        super.init(size: size)

        self.addChild(self.joystick)

        if debug {
            self.coordinateLabel = SKLabelNode(text: "")
            self.coordinateLabel.horizontalAlignmentMode = .left
            self.coordinateLabel.fontSize = 15
            self.coordinateLabel.fontColor = .black
            self.coordinateLabel.fontName = "AvenirNext-Bold"
            self.coordinateLabel.position = CGPoint(x: 20, y: self.size.height - 20)
            self.name = "coordinate label"
            self.addChild(self.coordinateLabel)
        }
        
        if debug {
            let inputCircle = SKShapeNode(circleOfRadius: Circle(at: CGPoint(x: 0, y: size.height), with: size.width / 2).radius)
            inputCircle.fillColor = .clear
            inputCircle.strokeColor = .lightGray
            inputCircle.position.x = Circle(at: CGPoint(x: 0, y: 0), with: size.width / 2).position.x
            inputCircle.position.y = Circle(at: CGPoint(x: 0, y: 0), with: size.width / 2).position.y
            inputCircle.name = "input bound"
            self.addChild(inputCircle)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.onTouchesBegan(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.onTouchesMoved(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.onTouchesCancelled(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.joystick.onTouchesEnded(touches, with: event, for : self)
        updateCoordinates(touches)
    }
    
    fileprivate func updateCoordinates(_ touches : Set<UITouch>) {
        if debug {
            self.coordinateLabel.text =  "Coordinates - current: x=\(Int((touches.first?.location(in: self.joystick).x)!)) · y=\(Int((touches.first?.location(in: self.joystick).y)!)) - previous: x=\(Int((touches.first?.previousLocation(in: self).x)!)) · y=\(Int((touches.first?.previousLocation(in: self).y)!))"
        }
    }
}

class Joystick : SKNode {
    
    let firstInputCircle : Circle
    
    let joystickMaxMove = CGFloat(30)
    let joystickMaxMoveBounds = CGFloat(30) - 4
    let joystickMininumMoveDistance : CGFloat = 2

    var motionActive = false

    var joystickInner : SKShapeNode!
    var joystickOuter : SKShapeNode!
    
    var beganPosition : CGPoint!
    var beganTime : Int64
    var longPress = false
    var moveStarted = false
    var distanceTolerance : CGFloat!
    
    var tapAt : ((_ tapPoint : CGPoint) -> ())!
    var moveTo : ((_ velocity : CGFloat, _ direction : CGFloat) -> ())!

    init(name : String = "Joystick", firstInputIn : Circle) {
        self.beganTime = Date().millisecondsSince1970
        self.joystickInner = SKShapeNode(circleOfRadius: 20)
        self.joystickInner.fillColor = .red
        self.joystickInner.strokeColor = .orange
        self.joystickInner.alpha = 20

        self.joystickOuter = SKShapeNode(circleOfRadius: 20 + joystickMaxMove)
        self.joystickOuter.fillColor = .clear
        self.joystickOuter.strokeColor = .red
        
        self.firstInputCircle = firstInputIn

        super.init()
        self.name = name
        self.addChild(self.joystickInner)
        self.addChild(self.joystickOuter)
    }
    
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchMyTouch(touches, for: scene) else {return}
        self.distanceTolerance = myTouch.majorRadiusTolerance > self.joystickMininumMoveDistance ? myTouch.majorRadiusTolerance : self.joystickMininumMoveDistance
        self.beganTime = Date().millisecondsSince1970
        initLongTouchTimer(myTouch)
    }

    fileprivate func initLongTouchTimer(_ myTouch: UITouch) {
        Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(longPress(timer:)), userInfo: (beganTime: self.beganTime, event: myTouch), repeats: false)
    }
    
    @objc func longPress(timer : Timer) {
        guard let eventData = timer.userInfo as? (beganTime: Int64, event: UITouch) else {fatalError("long press value not of type (beganTime: Int64, event: UITouch)")}
        if eventData.beganTime == self.beganTime {
            self.beganPosition = self.position
            self.longPress = true
            self.joystickInner.glowWidth = 1.0
            self.joystickOuter.glowWidth = 2.0

            self.position = calculateNewPosition(start: self.position, withDifference: eventData.event.location(in: self))
        }
    }

    @inline(__always) private func calculateNewPosition(start : CGPoint, withDifference diff : CGPoint) -> CGPoint {
        return start + diff
    }
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchMyTouch(touches, for: scene) else {return}
        let myPosition = myTouch.location(in: scene)
        let distanceAndAngle = distanceAndAngleBetween(self.position, myPosition)
        
        if !self.motionActive {
            if distanceAndAngle.distance >= self.distanceTolerance {
                self.motionActive = true
            }
        }
        
        if self.motionActive {
            if distanceAndAngle.distance > self.joystickMaxMoveBounds {
                let boundsOvergo = distanceAndAngle.distance - self.joystickMaxMoveBounds
                print("boundsOvergo: \(boundsOvergo)")
                let vX = cos(distanceAndAngle.radians)
                let vY = sin(distanceAndAngle.radians)
                print("Old self position: \(self.position) - new self position: \(self.position + CGPoint(x: vX * boundsOvergo, y: vY * boundsOvergo) )")
                self.position = self.position + CGPoint(x: vX * boundsOvergo, y: vY * boundsOvergo)
            } else {
                self.joystickInner.position = myTouch.location(in: self)
            }
        }
    }
    
    func onTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchMyTouch(touches, for: scene) else {return}
        print("cancelled")
    }
    
    func onTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, for scene : SKScene) {
        guard let myTouch = fetchMyTouch(touches, for: scene) else {return}
        self.beganTime = Date().millisecondsSince1970
        if !longPress && self.tapAt != nil {
            tapAt(myTouch.location(in: scene))
        }

        if self.longPress {
            self.joystickInner.glowWidth = 0
            self.joystickOuter.glowWidth = 0
            self.moveStarted = false
            self.motionActive = false
            if self.beganPosition != nil {
                self.position = self.beganPosition
                self.joystickInner.position = CGPoint(x: 0, y: 0)
                self.beganPosition = nil
            }
        }
        self.longPress = false
        print("Ended - self.position: \(self.position)")
    }
    
    private func fetchMyTouch(_ touches: Set<UITouch>, for scene : SKScene) -> UITouch! {
        for touch in touches {
            let location = touch.location(in: scene)
            if !self.longPress && isPositionIn(circle : self.firstInputCircle, withPosition: location) {
                return touch
            }
            if isAround(location: self.position, withPosition: location) {
                return touch
            }
        }
        return nil
    }
    
    @inline(__always) private func isAround(location: CGPoint, withPosition position : CGPoint) -> Bool {
        let place = Circle(at: location, with: 40)
        return isPositionIn(circle: place, withPosition: position)
    }
    
    @inline(__always) private func isPositionIn(circle: Circle, withPosition position : CGPoint) -> Bool {
        let length = position.distance(to: CGPoint(x: circle.position.x, y: circle.position.y))
        return length < circle.radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func distanceAndAngleBetween(_ from : CGPoint, _ to : CGPoint) -> (distance: CGFloat, velocity : CGFloat, radians : CGFloat) {
        let dist = from.distance(to: to)
        let velocity = map(dist, vallow: 0, valhi: dist, tarlow: 0, tarhi: 1)
        let angle = from.angle(to)
        return (distance: dist, velocity: velocity, radians: angle)
    }
}

struct Circle {
    var position : CGPoint
    var radius : CGFloat
    
    init(at position : CGPoint, with radius : CGFloat) {
        self.position = position
        self.radius = radius
    }
}

fileprivate extension CGPoint {
    
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
    
    
}


fileprivate extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}


@inline(__always) func map(_ value : CGFloat, vallow : CGFloat = 0, valhi : CGFloat = 1, tarlow : CGFloat = 0, tarhi : CGFloat) -> CGFloat {
    assert(value >= vallow && value <= valhi, "value (\(value) not in range \(vallow) - \(valhi)")
    return tarlow + (tarhi - tarlow) * ((value - vallow) / (valhi - vallow))
}
