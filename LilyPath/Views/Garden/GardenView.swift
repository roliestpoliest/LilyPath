//
//  GardenView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct GardenView: View {
    @ObservedObject private var userPlantManager = UserPlantManager.shared

    var body: some View {
        NavigationStack {
            VStack {
                GardenNavigationLink(
                    title: "Your Garden",
                    destination: PlantGalleryView())

                YourGardenView()

                // TODO: replace with current plant popup
                GardenNavigationLink(
                    title: "Current Plant", destination: GardenView())

                Spacer()
            }
            .background(Color.mainBackground)
        }
    }
}

struct YourGardenView: View {
    @ObservedObject private var userPlantManager = UserPlantManager.shared

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 6)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(userPlantManager.getUserPlantsSorted(), id: \.id) { plant in
                Image(plant.currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 60)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.customBrown)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 3)
                        .stroke(Color.customPink, lineWidth: 6)
                )
        )
    }
}

struct GardenNavigationLink<Destination: View>: View {
    let title: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                ViewTitle(title: title)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.viewTitle)
                    .foregroundColor(Color.customBrown)
            }
        }
    }
}

#Preview {
    GardenView()
        .background(Color.mainBackground)
        .padding(.horizontal, 30)
}
