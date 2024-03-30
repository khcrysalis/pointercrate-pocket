//
//  Auth.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation

// Authorization: Basic <"username:password" base64 encoded>

extension PointercrateAPI {
  ///https://pointercrate.com/documentation/account/#login
  public func login(
    username: String,
    password: String
  ) async throws -> AuthResponse {
    guard
      let pairStringB64 = "\(username):\(password)".data(using: .utf8)?.base64EncodedString()
    else { throw URLError(.badURL) }
    
    let data: AuthResponse = try await postReq(path: "v1/auth", data: nil, headers: ["Authorization": "Basic \(pairStringB64)"], useAuth: false)
    
    Self.auth.populate(with: data)
    return data
  }
  
  public func logout() {
    Self.auth.destroy()
  }
  
}
