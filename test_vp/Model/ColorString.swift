//
//  ColorString.swift
//  test_vp
//
//  Created by Bryce Li on 2/12/24.
//

import Foundation
import SwiftUI

struct ColorString:Identifiable {
    var id: UUID
    var string: String
    var color: Color
    
    init(id: UUID, string: String, color: Color) {
        self.id = id
        self.string = string
        self.color = color
    }
}
