//
//  TileData.swift
//  Kanji2048
//
//  Created by HOKO on 2022/03/22.
//

import Foundation
import UIKit

class TileData {
    var num:Int = 0
    var char:String = ""
    var notCombined:Bool = true
    var generated:Bool = false
    var moveVec:[Int] = [0, 0]
    
    func addVec(_ vec:[Int]){
        self.moveVec[0] += vec[0]
        self.moveVec[1] += vec[1]
    }
}
