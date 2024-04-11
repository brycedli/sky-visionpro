//
//  ColorStringsViewModel.swift
//  test_vp
//
//  Created by Bryce Li on 2/12/24.
//

import Foundation

class ColorStringsViewModel {
    static var stub = [ColorString(id: UUID(), string: "blue", color: .blue),
                       ColorString(id: UUID(), string: "black", color: .black),
                       ColorString(id: UUID(), string: "red", color: .red),
    ]
    var colorStrings : [ColorString] = stub;
    
}
