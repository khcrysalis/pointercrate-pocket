//
//  Common.swift
//  pointercrate
//
//  Created by samara on 3/26/24.
//

import Foundation

public struct DemonResponse: Codable {
  let data: Demons
}

public struct Demon: Codable {
  public var id: Int
  public var position: Int
  public var name: String
}

public struct Player: Codable {
  public var id: Int
  public var name: String
  public var banned: Bool
}

public struct Nationality: Codable {
  public var country_code: String
  public var nation: String
  public var subdivision: String?
}

public struct User: Codable, Identifiable {
  public var display_name: String?
  public var id: Int
  public var name: String
//  public var permissions: // probably an optionset but cba rn
  
}
