//
//  HowToPlayView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/24/24.
//

import SwiftUI

struct HowToPlayView: View {
    @Binding var showSheet: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { showSheet = false }) {
                    IconImage(
                        icon: .x, font: .system(size: 30), color: .redButton)
                }
                .padding(.top, 30)
            }

            Text("How to Play")
                .font(.viewTitle)
                .foregroundColor(.customBrown)

            Divider()
                .padding(.bottom)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(rules, id: \.self) { rule in
                        HStack(alignment: .top, spacing: 15) {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(Color.darkGreen)
                                .font(.customBody)

                            Text(rule)
                                .font(.customBody)
                                .foregroundColor(.customBrown)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 30)
        .background(Color.mainBackground.ignoresSafeArea())
    }

    private var rules: [String] {
        [
            "Welcome to Lily Path!",
            "As a welcome gift, you’ve received a Lily, 1000 water points, and 5 gems to help you get started on your journey.",
            "Take walks to grow your plant – every step counts!",
            "Convert your steps into water points – 1 step equals 1 water point.",
            "Collect 1,000 water points to water your plant.",
            "Keep watering your plant to unlock its next growth stage.",
            "Looking for a new plant? Use gems to buy one or visit your garden's plant gallery to swap it out.",
            "Earn gems by watering and completing your plant. Level up your plant to earn even more gems and unlock new plants!",
            "Complete daily tasks to earn bonus water points and gems. Keep the rewards coming!"
        ]
    }
}

#Preview {
    HowToPlayView(showSheet: .constant(true))
}
