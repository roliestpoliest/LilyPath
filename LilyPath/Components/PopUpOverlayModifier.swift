//
//  PopUpOverlayModifier.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/5/24.
//

import SwiftUI
struct PopUpOverlayModifier<PopUpContent: View>: ViewModifier {
    @Binding var isVisible: Bool
    let popUpContent: () -> PopUpContent
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isVisible {
                        // Dimmed background
                        Color.mainBackground.opacity(0.4)
                            .ignoresSafeArea()
                        popUpContent()
                    }
                }
                .animation(.easeInOut, value: isVisible)
            )
    }
}

extension View {
    func popUpOverlay<PopUpContent: View>(
        isVisible: Binding<Bool>,
        @ViewBuilder content: @escaping () -> PopUpContent
    ) -> some View {
        self.modifier(PopUpOverlayModifier(isVisible: isVisible, popUpContent: content))
    }
}
