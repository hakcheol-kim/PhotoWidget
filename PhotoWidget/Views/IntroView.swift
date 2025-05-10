//
//  IntroView.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI

import SwiftUI

struct IntroView: View {
    @EnvironmentObject var appState: AppState
    @State private var animate = false
    let chars: [String] = "포토위젯".map { String($0) }

    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            
            HStack(spacing: 8) {
                ForEach(Array(chars.enumerated()), id: \.offset) { index, ch in
                    Text(ch)
                        .font(.system(size: 50))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
            }
            .overlay {
                GeometryReader { geo in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.black.opacity(0), .black.opacity(0.3), .black.opacity(0)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 10, height: geo.size.height)
                        .opacity(animate ? 0 : 1)
                        .animation(.easeInOut(duration: 2), value: animate)
                        .offset(x: animate ? geo.size.width : 0, y: 0)
                }
            }
        }
        .onAppear {
            withAnimation {
                animate = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                appState.appScene = .home
            }
        }
    }
}

#Preview {
    IntroView()
        .environmentObject(AppState())
}
