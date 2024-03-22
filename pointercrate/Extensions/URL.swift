//
//  URL.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation

extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        var parameters = [String: String]()
        for queryItem in queryItems {
            parameters[queryItem.name] = queryItem.value
        }
        return parameters
    }
}
