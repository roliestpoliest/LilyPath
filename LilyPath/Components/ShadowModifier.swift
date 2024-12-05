//
//  CustomShadowModifier.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/5/24.
//

import SwiftUI

// Shadow constants for view components
struct ShadowConstants {
    static let radius: CGFloat = 3
    static let yOffset: CGFloat = 3
}

struct CustomShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .black.opacity(0.1),
                radius: ShadowConstants.radius,
                x: 0,
                y: ShadowConstants.yOffset
            )
    }
}

struct DarkerCustomShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .black.opacity(0.25),
                radius: ShadowConstants.radius,
                x: 0,
                y: ShadowConstants.yOffset
            )
    }
}

extension View {
    func customShadow() -> some View {
        self.modifier(CustomShadowModifier())
    }

    func darkCustomShadow() -> some View {
        self.modifier(DarkerCustomShadowModifier())
    }
}
