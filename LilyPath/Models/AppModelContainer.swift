//
//  Persistence.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/2/24.
//

import SwiftData

class AppModelContainer {
    static let shared = AppModelContainer()
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: CurrencyModel.self, TaskModel.self, UserPlantModel.self, BasePlantModel.self)
        } catch {
            fatalError("Failed to initialize the ModelContainer: \(error)")
        }
    }
}
