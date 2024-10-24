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

            ScrollView {
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
            "Take walks to grow your plant – every step can help it grow!",
            "For every step, you earn one water point.",
            "Collect 1,000 water points to earn a water for your plant.",
            "Water your plant 10 times to unlock its next growth stage!",
            "Miss a day of watering, and your plant will start to wilt. Don’t let it wilt!",
            "Looking for a new plant? Use gems to buy one or head to your garden's plant gallery to swap it out.",
            "Complete daily tasks to earn extra water points and gems – keep the rewards coming!"
        ]
    }
}

#Preview {
    HowToPlayView(showSheet: .constant(true))
}
