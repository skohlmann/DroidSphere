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

@inline(__always) func map(_ value : Float, vallow : Float = 0, valhi : Float = 1, tarlow : Float = 0, tarhi : Float) -> Float {
    assert(value >= vallow && value <= valhi, "value (\(value) not in range \(vallow) - \(valhi)")
    return tarlow + (tarhi - tarlow) * ((value - vallow) / (valhi - vallow))
}

@inline(__always) func map(_ value : Double, vallow : Double = 0, valhi : Double = 1, tarlow : Double = 0, tarhi : Double) -> Double {
    assert(value >= vallow && value <= valhi, "value (\(value) not in range \(vallow) - \(valhi)")
    return tarlow + (tarhi - tarlow) * ((value - vallow) / (valhi - vallow))
}


func map(_ value : CGFloat, vallow : CGFloat = 0, valhi : CGFloat = 1, tarlow : CGFloat = 0, tarhi : CGFloat) -> CGFloat {
    assert(value >= vallow && value <= valhi, "value (\(value) not in range \(vallow) - \(valhi)")
    return tarlow + (tarhi - tarlow) * ((value - vallow) / (valhi - vallow))
}
