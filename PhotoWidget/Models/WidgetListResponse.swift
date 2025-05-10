//
//  WidgetListResponse.swift
//  PhotoWidget
//
//  Created by 김학철 on 5/9/25.
//

import SwiftUI

struct WidgetListResponse: Codable {
    var code: Int
    var message: String
    var data: [String]
    
    enum CodingKeys: CodingKey {
        case code
        case message
        case data
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(Int.self, forKey: .code)  ?? 0
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.data = try container.decodeIfPresent([String].self, forKey: .data) ?? []
    }
}
