//
//  GetRankedDemons.swift
//
//
//  Created by [Your Name] on [Current Date].
//

import Foundation

extension PointercrateAPI {
    ///https://pointercrate.com/documentation/demons#list-ranked-demons
    public func getRankedDemons(name: String? = nil,
                                nameContains: String? = nil,
                                requirement: Int? = nil,
                                verifierID: Int? = nil,
                                publisherID: Int? = nil,
                                verifierName: String? = nil,
                                publisherName: String? = nil,
                                limit: Int? = nil,
                                after: Int? = nil,
                                before: Int? = nil
    ) async throws -> [Demons]
    {
        let queryItems: [URLQueryItem?] = [
            name.map { URLQueryItem(name: "name", value: $0) },
            nameContains.map { URLQueryItem(name: "name_contains", value: $0) },
            requirement.map { URLQueryItem(name: "requirement", value: String($0)) },
            verifierID.map { URLQueryItem(name: "verifier_id", value: String($0)) },
            publisherID.map { URLQueryItem(name: "publisher_id", value: String($0)) },
            verifierName.map { URLQueryItem(name: "verifier_name", value: $0) },
            publisherName.map { URLQueryItem(name: "publisher_name", value: $0) },
            limit.map { URLQueryItem(name: "limit", value: String($0)) },
            after.map { URLQueryItem(name: "after", value: String($0)) },
            before.map { URLQueryItem(name: "before", value: String($0)) }
        ]
        
        let compactQueryItems = queryItems.compactMap { $0 }
        
        return try await getReq(path: "/v2/demons/listed/", query: compactQueryItems)
    }
    /// https://pointercrate.com/documentation/demons#list-all-demons
    public func getDemons(name: String? = nil,
                          nameContains: String? = nil,
                          requirement: Int? = nil,
                          verifierID: Int? = nil,
                          publisherID: Int? = nil,
                          verifierName: String? = nil,
                          publisherName: String? = nil,
                          limit: Int? = nil,
                          after: Int? = nil,
                          before: Int? = nil
    ) async throws -> [Demons]
    {
        let queryItems: [URLQueryItem?] = [
            name.map { URLQueryItem(name: "name", value: $0) },
            nameContains.map { URLQueryItem(name: "name_contains", value: $0) },
            requirement.map { URLQueryItem(name: "requirement", value: String($0)) },
            verifierID.map { URLQueryItem(name: "verifier_id", value: String($0)) },
            publisherID.map { URLQueryItem(name: "publisher_id", value: String($0)) },
            verifierName.map { URLQueryItem(name: "verifier_name", value: $0) },
            publisherName.map { URLQueryItem(name: "publisher_name", value: $0) },
            limit.map { URLQueryItem(name: "limit", value: String($0)) },
            after.map { URLQueryItem(name: "after", value: String($0)) },
            before.map { URLQueryItem(name: "before", value: String($0)) }
        ]
        
        let compactQueryItems = queryItems.compactMap { $0 }
        
        return try await getReq(path: "/v2/demons/", query: compactQueryItems)
    }
    /// https://pointercrate.com/documentation/demons#demon-retrieval
    public func getDemon(id: Int, ifMatch: String? = nil, ifNoneMatch: String? = nil) async throws -> DemonResponse {
        var headers = [String: String]()
        
        if let ifMatchValue = ifMatch {
            headers["If-Match"] = ifMatchValue
        }
        
        if let ifNoneMatchValue = ifNoneMatch {
            headers["If-None-Match"] = ifNoneMatchValue
        }
        
        let data = try await PointercrateAPI.shared.makeRequest(path: "/v2/demons/\(id)/", headers: headers, useAuth: false)
        
        return try PointercrateAPI.decoder.decode(DemonResponse.self, from: data)
    }
    
}
