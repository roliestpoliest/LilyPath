//
//  FontSizes.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/3/24.
//

import SwiftUI

extension Font {
    static var viewTitle: Font {
        return .system(size: 32, weight: .bold, design: .rounded)
    }

    static var customBody: Font {
        return .system(size: 16, weight: .semibold, design: .rounded)
    }
    
    // for level, water pts, gems
    static var userInfo: Font {
        return .system(size: 14, weight: .semibold, design: .rounded)
    }
    
    static var statsCard: Font {
        return .system(size: 18, weight: .medium, design: .rounded)
    }
    
    static var statsCategory: Font {
        return .system(size: 16, weight: .bold, design: .rounded)
    }
    
    static var statsBody: Font {
        return .system(size: 16, weight: .medium, design: .rounded)
    }
    
    static var popupTitle: Font {
        return .system(size: 20, weight: .bold, design: .rounded)
    }
    
    static var tabLabel: Font {
        return .system(size: 12, weight: .semibold, design: .rounded)
    }
}
