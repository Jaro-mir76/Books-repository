//
//  ViewModel.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 06.03.2025.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    var backgroundColor: Color = Color.gray.opacity(0.2)
    
    func opacityHelper(double: Double) -> Double {
        if double <= 0 {
            return 0
        } else if double > 0, double < 100 {
            return double * 0.01
        } else {
            return 1
        }
    }
}
