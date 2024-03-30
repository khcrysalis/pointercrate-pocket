//
//  AuthResponse.swift
//  pointercrate
//
//  Created by Lakhan Lothiyi on 30/03/2024.
//

import Foundation

public struct AuthResponse: Codable {
  public var user: User
  public var token: String
}
