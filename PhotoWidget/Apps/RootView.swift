//
//  RootView.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        Group {
            if appState.appScene == .intro {
                IntroView()
                    .environmentObject(appState)
            }
            else {
                HomeView()
                    .environmentObject(appState)
            }
        }
        .preferredColorScheme(Theme.light.colorScheme)
        .background(Color.systemBackground)
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
