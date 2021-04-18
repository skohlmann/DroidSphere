//
//  Map.swift
//  Droid
//
//  Created by Sascha Kohlmann on 17.04.21.
//


func map(_ value : Float, vallow : Float = 0, valhi : Float = 1, tarlow : Float = 0, tarhi : Float) -> Float {
    assert(value >= vallow && value <= valhi, "value (\(value) not in range \(vallow) - \(valhi)")
    return tarlow + (tarhi - tarlow) * ((value - vallow) / (valhi - vallow))
}

func map(_ value : Double, vallow : Double = 0, valhi : Double = 1, tarlow : Double = 0, tarhi : Double) -> Double {
    assert(value >= vallow && value <= valhi, "value (\(value) not in range \(vallow) - \(valhi)")
    return tarlow + (tarhi - tarlow) * ((value - vallow) / (valhi - vallow))
}
