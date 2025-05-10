//
//  CError.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI
import Foundation

enum CError: Error {
    case invalidURL
    case decodingFailed
    case sessionDenied
    case badServerResponse
    case origin(Error)
}

extension CError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다"
        case .decodingFailed:
            return "데이터 파싱에 실패했습니다."
        case .sessionDenied:
            return "세션 종료되었습니다."
        case .origin(let error):
            return error.localizedDescription
        case .badServerResponse:
            return "서버에서 반환한 데이터가 부적합합니다."
        default:
            "Unknown error"
        }
    }
}
