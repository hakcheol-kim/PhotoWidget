//
//  ApiClient.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI
import Foundation

let serverHost = "api.jsonbin.io"
 
class ApiClient {
    static var shared = ApiClient()
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
        session.configuration.timeoutIntervalForRequest = 10
        session.configuration.timeoutIntervalForResource = 60
    }
    
    
    static func request<T: Codable>(_ router: Router, decoder: T.Type) async throws -> Result<T, CError> {
        let (data, response) = try await ApiClient.shared.session.data(for: router.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw CError.badServerResponse
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            throw CError.decodingFailed
        }
    }
}
