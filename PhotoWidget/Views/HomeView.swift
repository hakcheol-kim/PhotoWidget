//
//  HomeView.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI
import SFSafeSymbols
import Combine

class HomeViewModel: ObservableObject {
    @Published var widgetUrls: [String] = []
    @Published var selectedIndex: Int = 0
    @Published var selectedImageUrl: String?
    @Published var isShowPreview: Bool = false
    private var cancelBag: Set<AnyCancellable> = []
    init() {
        binder()
    }
    
    enum Action {
        case onAppear
        case requestWidgetList
        case previewBtnTap
    }
    private func binder() {
        $selectedIndex
            .map { index -> String? in
                print(index)
                var url: String?
                if index < self.widgetUrls.count {
                    url = self.widgetUrls[index]
                    print("== changeUrl: \(url ?? "")")
                }
                return url
            }
            .assign(to: \.selectedImageUrl, on: self)
            .store(in: &cancelBag)
    }
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            send(.requestWidgetList)
            return
        case .requestWidgetList:
            Task {
                let response = try await ApiClient.request(.widgetList(meta: false), decoder: WidgetListResponse.self)
                print("response: \(response)")
                await MainActor.run {
                    switch response {
                    case .success(let result):
                        let urls = result.data
//                        let urls = result.data.filter({ $0.hasSuffix(".jpeg") || $0.hasSuffix(".png")})
                        if !urls.isEmpty {
                            self.widgetUrls = urls
                            self.selectedIndex = 0
                            self.selectedImageUrl = urls[selectedIndex]
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            return
        case .previewBtnTap:
            isShowPreview.toggle()
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        NavigationStack(path: $appState.naviPath) {
            ZStack {
                if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                        .ignoresSafeArea()
                    
                    if let url = vm.selectedImageUrl {
                        AsyncCachedImage(url: url)
                            .scaledToFill()
                            .frame(width: 300, height: 300*1.8)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .offset(x: 0, y: -100)
                    }
                }
                
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            print("Go to related theme 클릭")
                        } label: {
                            Text("Go to related theme")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background {
                                    Capsule()
                                        .foregroundColor(.black.opacity(0.3))
                                }
                                .contentShape(Rectangle())
                            
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            print("구매하기 클릭")
                        } label: {
                            Text("구매하기")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                            
                                .background {
                                    Capsule()
                                        .fill(.indigo)
                                        .shadow(radius: 3)
                                }
                        }
                        
                        
                        Button {
                            vm.send(.previewBtnTap)
                            print("구성화면 보기 클릭")
                        } label: {
                            Image(systemSymbol: .squareStack)
                                .rotationEffect(.degrees(90))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(16)
                                .background {
                                    Circle()
                                        .fill(.indigo)
                                        .shadow(radius: 3)
                                }
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 16)
                
                
                if vm.isShowPreview {
                    PreScreenView(isPresent: $vm.isShowPreview, selectedIndex: $vm.selectedIndex, urls: vm.widgetUrls)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: vm.isShowPreview)
                }
            }
            .background {
                if let url = vm.selectedImageUrl {
                    AsyncCachedImage(url: url)
                        .scaledToFill()
                        .ignoresSafeArea()
                }
                
            }
            .onAppear {
                vm.send(.onAppear)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
