//
//  GetRankedDemons.swift
//
//
//  Created by [Your Name] on [Current Date].
//

import Foundation

extension PointercrateAPI {
    public func getRankedDemons(filter: String? = nil, limit: Int? = nil) async throws -> [RankedDemons] {
        var queryItems: [URLQueryItem] = []
        
        if let filter = filter {
            queryItems.append(URLQueryItem(name: "filter", value: filter.description))
        }
        
        /// Limit is 100, you cannot go further,
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        
        return try await getReq(path: "/v2/demons/listed/", query: queryItems)
    }
}
