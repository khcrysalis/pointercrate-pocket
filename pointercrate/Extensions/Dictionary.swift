//
//  Dictionary.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation

extension Dictionary where Key == String, Value == String {
  func urlEncodedString() -> String {
    let encodedPairs = self.map { key, value in
      let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "x"
      let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "x"
      return "\(encodedKey)=\(encodedValue)"
    }
    return encodedPairs.joined(separator: "&")
  }
}

extension String: LocalizedError {
  public var errorDescription: String? { return self }
}
