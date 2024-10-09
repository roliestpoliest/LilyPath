//
//  PlantModel.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/3/24.
//

import SwiftUI

final class BasePlantModel: Identifiable {
    let id = UUID()
    let species: String
    let requiredLevelToBuy: Int
    let price: Int
    let stepGoal: Int
    let stageStepGoals: [Int]
    let stageImages: [String]
    
    init(
        species: String, requiredLevelToBuy: Int, price: Int,
        stageStepGoals: [Int]
    ) {
        self.species = species
        self.requiredLevelToBuy = requiredLevelToBuy
        self.price = price
        self.stageStepGoals = stageStepGoals
        self.stepGoal = stageStepGoals.reduce(0, +)
        self.stageImages = (1...5).map { "\(species) Stage \($0)" }
    }
    
    // Predefined plants with price included
    static let buttercup = BasePlantModel(
        species: "Buttercup",
        requiredLevelToBuy: 2,
        price: 100,
        stageStepGoals: [100, 200, 300, 400, 0]
    )
    
    static let carnation = BasePlantModel(
        species: "Carnation",
        requiredLevelToBuy: 3,
        price: 150,
        stageStepGoals: [150, 250, 350, 450, 0]
    )
    
    static let chamomile = BasePlantModel(
        species: "Chamomile",
        requiredLevelToBuy: 4,
        price: 120,
        stageStepGoals: [120, 220, 320, 420, 0]
    )
    
    static let delphinium = BasePlantModel(
        species: "Delphinium",
        requiredLevelToBuy: 5,
        price: 130,
        stageStepGoals: [130, 230, 330, 430, 0]
    )
    
    static let lavender = BasePlantModel(
        species: "Lavender",
        requiredLevelToBuy: 6,
        price: 110,
        stageStepGoals: [110, 210, 310, 410, 0]
    )
    
    static let lily = BasePlantModel(
        species: "Lily",
        requiredLevelToBuy: 0,
        price: 100,
        stageStepGoals: [100, 200, 300, 400, 0]
    )
    
    static let lotus = BasePlantModel(
        species: "Lotus",
        requiredLevelToBuy: 7,
        price: 180,
        stageStepGoals: [180, 280, 380, 480, 0]
    )
    
    static let peony = BasePlantModel(
        species: "Peony",
        requiredLevelToBuy: 8,
        price: 160,
        stageStepGoals: [160, 260, 360, 460, 0]
    )
    
    static let petunia = BasePlantModel(
        species: "Petunia",
        requiredLevelToBuy: 3,
        price: 140,
        stageStepGoals: [140, 240, 340, 440, 0]
    )
    
    static let rose = BasePlantModel(
        species: "Rose",
        requiredLevelToBuy: 9,
        price: 190,
        stageStepGoals: [190, 290, 390, 490, 0]
    )
    
    static let sunflower = BasePlantModel(
        species: "Sunflower",
        requiredLevelToBuy: 4,
        price: 150,
        stageStepGoals: [150, 250, 350, 450, 0]
    )
    
    static let allPlants = [
        buttercup, carnation, chamomile, delphinium, lavender, lily, lotus,
        peony, petunia, rose, sunflower,
    ]
}
