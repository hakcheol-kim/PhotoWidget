//
//  AsynCacheImage.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI

struct AsyncCachedImage<Content: View>: View {
    let url: URL?
    private let scale: CGFloat
    private let cacheType: ImageCacheType
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Content
    
    @State private var loadedImage: UIImage?
    
    // ✅ 1. 기본 init (이미지만 표시, 실패 시 빈 뷰)
    public init(url: String, scale: CGFloat = UIScreen.main.scale, cacheType: ImageCacheType = .disk) where Content == Image {
        self.url = URL(string: url)
        self.scale = scale
        self.cacheType = cacheType
        self.transaction = Transaction()
        self.content = { $0 }
        self.placeholder = { Image(systemName: "photo") }
    }
    
    // ✅ 2. 커스텀 content + placeholder
    init(
        url: String,
        scale: CGFloat = UIScreen.main.scale,
        cacheType: ImageCacheType = .disk,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Content
    ) {
        self.url = URL(string: url)
        self.scale = scale
        self.cacheType = cacheType
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let uiImage = loadedImage {
                content(
                    Image(uiImage: uiImage)
                        .resizable()
                )
            } else {
                placeholder()
            }
        }
        .transaction { $0 = transaction }
        .task(id: url) {
            guard let url = url else { return }
            loadedImage = nil
            do {
                let data = try await ImageCacheManager.shared.loadImageData(from: url, cacheType: cacheType)
                if let uiImage = UIImage(data: data, scale: scale) {
                    withTransaction(transaction) {
                        self.loadedImage = uiImage
                    }
                }
            } catch {
                print("❌ 이미지 로딩 실패: \(error)")
            }
        }
    }
}
