//
//  Glow.swift
//  Space Merchant
//
//  Created by Callum Birks on 27/01/2022.
//

import SwiftUI

extension View {
    func glow(color: Color = .white, radius: CGFloat = 10) -> some View {
        let opacityColor = color.opacity(0.5)
        return self
            .overlay(self.blur(radius: radius / 6))
            .shadow(color: opacityColor, radius: radius / 3)
            .shadow(color: opacityColor, radius: radius / 3)
            .shadow(color: opacityColor, radius: radius / 3)
    }
}
