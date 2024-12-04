//
//  ChartPeriod.swift
//  LilyPath
//
//  Created by Carolyn Heron on 12/3/24.
//


enum ChartPeriod: String, CaseIterable, Identifiable {
    case day = "Past Day"
    case week = "Past Week"
    case month = "Past Month"

    var id: String { self.rawValue }
}