//
//  Theme.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI

enum Theme: Int, Identifiable, CaseIterable {
    var id: Self { self }
    case light = 1
    case dark = 2
}

extension Theme {
    var title: String {
        switch self {
        case .light:
            return "🌝 Light"
        case .dark:
            return "🌚 Dark"
        }
    }
    var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    func toggle() -> Self {
        switch self {
        case .light:
            return .dark
        case .dark:
            return .light
        }
    }
}
