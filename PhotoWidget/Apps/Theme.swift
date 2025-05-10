//
//  Theme.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI

enum Theme: Int, Identifiable, CaseIterable {
    var id: Self { self }
    case system = 0
    case light = 1
    case dark = 2
}

extension Theme {
    var title: String {
        switch self {
        case .system:
            return "📱 System"
        case .light:
            return "🌝 Light"
        case .dark:
            return "🌚 Dark"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
