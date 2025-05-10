//
//  PreScreenView.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/10/25.
//

import SwiftUI
class PreScreenViewModel: ObservableObject {
    @Published var urls: [String]
    
    init(urls: [String]) {
        self.urls = urls
    }
}
struct PreScreenView: View {
    @GestureState private var dragOffset: CGFloat = 0
    @StateObject var vm: PreScreenViewModel
    @Binding var isPresent: Bool
    @Binding var selectedIndex: Int
    @StateObject private var appState = AppState.shared
    @Environment(\.colorScheme) var colorScheme
    
    init(isPresent: Binding<Bool>, selectedIndex: Binding<Int>, urls: [String]) {
        _isPresent = isPresent
        _selectedIndex = selectedIndex
        _vm = StateObject(wrappedValue: PreScreenViewModel(urls: urls))
    }
    
    var body: some View {
        
        ZStack {
            
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresent.toggle()
                }
            
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 20)
                    Capsule()
                        .fill(.gray2)
                        .frame(width: 60, height: 6)
                    
                    Spacer(minLength: 34)
                    
                    ScrollViewReader { reader in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: [GridItem(.fixed(geo.size.height*0.5))], spacing: 16) {
                                ForEach(Array(vm.urls.enumerated()), id: \.offset) { i, url in
                                    AsyncCachedImage(url: url)
                                        .scaledToFill()
                                        .frame(width: geo.size.width/2, height: geo.size.height*0.5)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .id(i)
                                        .onTapGesture(perform: {
                                            
                                        })
                                    
                                }
                            }
                            .padding(.horizontal, (geo.size.width - geo.size.width/2)/2)
                            //.offset(x: dragOffset)
                            .gesture(
                                DragGesture()
                                    .updating($dragOffset) { value, state, _ in
                                        state = value.translation.width
                                    }
                                    .onEnded { value in
                                        let threshold = geo.size.width * 0.2
                                        let direction: Int = value.translation.width < -threshold ? 1 : value.translation.width > threshold ? -1 : 0
                                        let newIndex = min(max(selectedIndex + direction, 0), vm.urls.count - 1)
                                        
                                        withAnimation {
                                            selectedIndex = newIndex
                                            reader.scrollTo(selectedIndex, anchor: .center)
                                        }
                                    }
                            )
                        }
                        .onAppear {
                            reader.scrollTo(selectedIndex, anchor: .center)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<vm.urls.count, id: \.self) { i in
                            Circle()
                                .fill(i == selectedIndex ? .label : .gray)
                                .frame(width: 8)
                            
                        }
                    }
                    Spacer()
                }
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.tertiarySystemBackground)
                }
                .frame(width: geo.size.width*0.9, height: geo.size.height*0.7)
                .offset(x: geo.size.width*0.05, y: geo.size.height*0.3)
            }
            .environment(\.colorScheme, appState.currentScheme ?? .light)
            .onTapGesture {
                switch appState.selectedTheme {
                case .system:
                    appState.selectedTheme = .light
                case .dark:
                    appState.selectedTheme = .light
                case .light:
                    appState.selectedTheme = .dark
                }
            }
        }
    }
    
   
}

#Preview {
    PreScreenView(isPresent: .constant(true),
                  selectedIndex: .constant(0),
                  urls: ["https://cdn.photowidget.net/Wallpaper/1716774590540805196/da1a30df08.webp",
                         "https://cdn.photowidget.net/Wallpaper/1716774419943176532/3e749f4943.webp",
                         "https://cdn.photowidget.net/Wallpaper/2cf34c842b/7ec22d8399.webp",
                         "https://cdn.photowidget.net/Wallpaper/1740044215342261397/2252276003.jpeg",
                         "https://cdn.photowidget.net/Wallpaper/1740044723885513208/3062465750.jpeg",
                         "https://cdn.photowidget.net/Wallpaper/1710765740947432655/8480330a12.webp"])
}
