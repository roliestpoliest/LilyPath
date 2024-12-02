//
//  FontSizes.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/3/24.
//

import SwiftUI

extension Font {
    // MARK: - General use
    static var viewTitle: Font {
        return .system(size: 32, weight: .bold, design: .rounded)
    }

    static var customBody: Font {
        return .system(size: 16, weight: .semibold, design: .rounded)
    }
    
    static var label: Font {
        return .system(size: 12, weight: .semibold, design: .rounded)
    }

    // MARK: - Home
    static var homeIcons: Font {
        return .system(size: 55, weight: .medium, design: .rounded)
    }
    
    static var rewards: Font {
        return .system(size: 10, weight: .medium, design: .rounded)
    }
    
    // MARK: - Garden
    static var currentPlant: Font {
        return .system(size: 24, weight: .bold, design: .rounded)
    }
    
    // MARK: - Stats
    static var statsCard: Font {
        return .system(size: 18, weight: .medium, design: .rounded)
    }

    static var statsBody: Font {
        return .system(size: 16, weight: .medium, design: .rounded)
    }
    
    static var statsBodyBold: Font {
        return .system(size: 16, weight: .bold, design: .rounded)
    }
    
    static var statsIcon: Font {
        return .system(size: 34, weight: .bold, design: .rounded)
    }
    
    // MARK: - Popup
    static var popupTitle: Font {
        return .system(size: 20, weight: .bold, design: .rounded)
    }
    
    static var popupBody: Font {
        return .system(size: 16, weight: .semibold, design: .rounded)
    }

    static var popupDetails: Font {
        return .system(size: 14, weight: .medium, design: .rounded)
    }
    
    static var stageLabel: Font {
        return .system(size: 12, weight: .bold, design: .rounded)
    }
    static var chartAxisLabels: Font {
        return .system(size: 10, weight: .bold, design: .rounded)
    }
}
