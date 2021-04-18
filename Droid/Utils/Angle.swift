//
//  Angle.swift
//  Droid
//
//  Created by Sascha Kohlmann on 17.04.21.
//

import CoreGraphics

let rad_to_deg : Double = 180.0 / .pi
let deg_to_rad : Double = .pi / 180.0

func radians(_ degrees : Double) -> Double {
    return degrees * deg_to_rad
}

func degrees(_ radians : Double) -> Double {
    return radians * rad_to_deg
}

func radians(_ degrees : Float) -> Float {
    return degrees * Float(deg_to_rad)
}

func degrees(_ radians : Float) -> Float {
    return radians * Float(rad_to_deg)
}

func radians(_ degrees : CGFloat) -> CGFloat {
    return degrees * CGFloat(deg_to_rad)
}

func degrees(_ radians : CGFloat) -> CGFloat {
    return radians * CGFloat(rad_to_deg)
}

