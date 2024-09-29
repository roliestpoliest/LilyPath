//
//  SplashScreenView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Spacer()
                Text("""
                     Ubiq 2024 -
                     Semester Project
                     """
                )
                .font(.largeTitle)
                .bold()
                .foregroundColor(.blue)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
