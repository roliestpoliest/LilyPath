//
//  ImageModifier.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/8/24.
//

import SwiftUI

struct WiltFlowerEffect: ViewModifier {
    let applyEffects: Bool

    func body(content: Content) -> some View {
        if applyEffects {
            content
                .brightness(0.15)
                .saturation(0.4)
                .colorMultiply(Color(hex: "#BD8B68"))
        } else {
            content
        }
    }
}
