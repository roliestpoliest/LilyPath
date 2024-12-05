//
//  SplashScreenView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = false
    @State private var showHowToPlay: Bool = false
    @State private var scaleAmount: CGFloat = 1

    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Spacer()
                HStack {
                    Text("LilyPath")
                        .font(.viewTitle)
                        .foregroundColor(.customBrown)

                    Image("Lily Stage 5")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 50, maxHeight: 50)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(scaleAmount)
            .background(Color.mainBackground)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    scaleAmount = 0.8
                }
                withAnimation(.easeIn(duration: 1.5).delay(0.5)) {
                    scaleAmount = 1.8
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if isFirstLaunch() {
                        showHowToPlay = true
                    } else {
                        isActive = true
                    }
                }
            }
            .sheet(isPresented: $showHowToPlay, onDismiss: {
                withAnimation {
                    isActive = true
                }
            }) {
                HowToPlayView(showSheet: $showHowToPlay)
            }
        }
    }

    private func isFirstLaunch() -> Bool {
        let userDefaults = UserDefaults.standard
        let hasLaunchedKey = "hasLaunchedBefore"

        if userDefaults.bool(forKey: hasLaunchedKey) {
            return false
        } else {
            userDefaults.set(true, forKey: hasLaunchedKey)
            return true
        }
    }
}

#Preview {
    SplashScreenView()
}
