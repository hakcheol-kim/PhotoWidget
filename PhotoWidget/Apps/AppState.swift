//
//  AppState.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI
enum AppScene {
    case intro
    case home
}

final class AppState: ObservableObject {
    static let shared = AppState()
    @Published var naviPath = NavigationPath()
    @Published var appScene: AppScene = .intro
    
}
