//
//  ImageCacheManager.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import Foundation
import UIKit
enum ImageCacheType {
    case memory
    case disk
}

final class ImageCacheManager {
    static let shared = ImageCacheManager()

    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        // Caches 폴더 설정
        if let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.cacheDirectory = cacheDir
        } else {
            fatalError("❌ 캐시 디렉토리 접근 실패")
        }
    }

    /// 이미지 데이터를 비동기적으로 로드
    func loadImageData(from url: URL, cacheType: ImageCacheType = .disk) async throws -> Data {
        let cacheKey = url.absoluteString as NSString

        // ✅ 1. 메모리 캐시 확인
        if let cachedData = memoryCache.object(forKey: cacheKey) {
            //print("=== cache memory ===")
            return cachedData as Data
        }
        var fileURL: URL? = nil
        if cacheType == .disk {
            // ✅ 2. 디스크 캐시 확인
             fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
            if fileManager.fileExists(atPath: fileURL!.path),
               let data = try? Data(contentsOf: fileURL!) {
                memoryCache.setObject(data as NSData, forKey: cacheKey)
                //print("=== cache disk ===")
                return data
            }
        }
        
        // ✅ 3. URL 다운로드
        let (data, _) = try await URLSession.shared.data(from: url)
        //print("=== cache request ===")
        // ✅ 저장: 메모리 + 디스크
        memoryCache.setObject(data as NSData, forKey: cacheKey)
        if cacheType == .disk, let fileURL = fileURL {
            try? data.write(to: fileURL, options: .atomic)
        }
        return data
    }
}
