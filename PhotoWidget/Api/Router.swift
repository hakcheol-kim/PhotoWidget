//
//  Router.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI
import Foundation

protocol Routable {
    var method: HTTPMethod { get }
    var entryPoint: String { get }
    var param: [String: Any]? { get }
    var urlRequest: URLRequest { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Router: Routable {
    case widgetList(meta: Bool)
}

extension Router {
    var method: HTTPMethod {
        switch self {
        case .widgetList(meta: _):
            return .get
        default:
            return .post
        }
    }
    
    var entryPoint: String {
        switch self {
        case .widgetList:
             return "/v3/b/680711f18561e97a5004bfb1"
        default:
            return "/v3/b/680711f18561e97a5004bfb1"
        }
    }
    var param: [String: Any]? {
        switch self {
        case .widgetList(meta: let meta):
            return ["meta": meta]
        default:
            return nil
        }
    }
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = serverHost
        urlComponents.path = entryPoint
        
        guard let url = urlComponents.url else {
            fatalError("❌ URL 생성 실패: \(urlComponents)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let param = param {
            switch self {
            case .widgetList:
                let queryItems = param.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                urlComponents.queryItems = queryItems
                
                if let newURL = urlComponents.url {
                    request.url = newURL
                }
            default:
                request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
            }
        }
        
        return request
    }
}
