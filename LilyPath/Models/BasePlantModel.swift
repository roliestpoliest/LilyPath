//
//  PlantModel.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/3/24.
//

import SwiftUI
import SwiftData

@Model
class BasePlantModel {
    var id: String
    var species: String
    var requiredLevelToBuy: Int
    var price: Int
    var overallStepGoal: Int
    var stageStepGoals: [Int]
    var stageImages: [String]
    var gemReward: Int
    
    init(
        id: String = UUID().uuidString,
        species: String,
        requiredLevelToBuy: Int,
        price: Int,
        gemReward: Int,
        stageStepGoals: [Int]
    ) {
        self.id = id
        self.species = species
        self.requiredLevelToBuy = requiredLevelToBuy
        self.price = price
        self.gemReward = gemReward
        self.stageStepGoals = stageStepGoals
        self.overallStepGoal = stageStepGoals.reduce(0, +)
        self.stageImages = (1...5).map { "\(species) Stage \($0)" }
    }
}

// Extension for predefined plants
extension BasePlantModel {
    static let lily = BasePlantModel(
        id: "1",
        species: "Lily",
        requiredLevelToBuy: 1,
        price: 5,
        gemReward: 6,
        stageStepGoals: [2000, 3000, 4000, 5000, 0]
    )
    
    static let buttercup = BasePlantModel(
        id: "2",
        species: "Buttercup",
        requiredLevelToBuy: 2,
        price: 6,
        gemReward: 7,
        stageStepGoals: [3000, 4000, 5000, 6000, 0]
    )
    
    static let carnation = BasePlantModel(
        id: "3",
        species: "Carnation",
        requiredLevelToBuy: 3,
        price: 7,
        gemReward: 8,
        stageStepGoals: [3000, 4000, 5000, 6000, 0]
    )
    
    static let petunia = BasePlantModel(
        id: "4",
        species: "Petunia",
        requiredLevelToBuy: 4,
        price: 8,
        gemReward: 9,
        stageStepGoals: [3000, 4000, 5000, 6000, 0]
    )
    
    static let chamomile = BasePlantModel(
        id: "5",
        species: "Chamomile",
        requiredLevelToBuy: 5,
        price: 9,
        gemReward: 10,
        stageStepGoals: [4000, 5000, 6000, 7000, 0]
    )
    
    static let sunflower = BasePlantModel(
        id: "6",
        species: "Sunflower",
        requiredLevelToBuy: 6,
        price: 10,
        gemReward: 11,
        stageStepGoals: [4000, 5000, 6000, 7000, 0]
    )
    
    static let delphinium = BasePlantModel(
        id: "7",
        species: "Delphinium",
        requiredLevelToBuy: 7,
        price: 11,
        gemReward: 12,
        stageStepGoals: [4000, 5000, 6000, 7000, 0]
    )
    
    static let lavender = BasePlantModel(
        id: "8",
        species: "Lavender",
        requiredLevelToBuy: 8,
        price: 12,
        gemReward: 13,
        stageStepGoals: [5000, 6000, 7000, 8000, 0]
    )
    
    static let lotus = BasePlantModel(
        id: "9",
        species: "Lotus",
        requiredLevelToBuy: 9,
        price: 13,
        gemReward: 14,
        stageStepGoals: [5000, 6000, 7000, 8000, 0]
    )
    
    static let peony = BasePlantModel(
        id: "10",
        species: "Peony",
        requiredLevelToBuy: 10,
        price: 14,
        gemReward: 15,
        stageStepGoals: [5000, 6000, 7000, 8000, 0]
    )
    
    static let rose = BasePlantModel(
        id: "11",
        species: "Rose",
        requiredLevelToBuy: 11,
        price: 15,
        gemReward: 16,
        stageStepGoals: [6000, 7000, 8000, 9000, 0]
    )
    
    static let allPlants: [BasePlantModel] = [
        lily, buttercup, carnation, petunia, chamomile, sunflower,
        delphinium, lavender, lotus, peony, rose,
    ]
}
