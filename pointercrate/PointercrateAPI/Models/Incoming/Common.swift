//
//  Common.swift
//  pointercrate
//
//  Created by samara on 3/26/24.
//

import Foundation

public struct DemonResponse: Codable {
    let data: Demons
    enum CodingKeys: String, CodingKey { case data }
}

public struct Demon: Codable {
    public var id: Int
    public var position: Int
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case id,
             position,
             name
    }
}

public struct Player: Codable {
    public var id: Int
    public var name: String
    public var banned: Bool
    
    enum CodingKeys: String, CodingKey {
        case id,
             name,
             banned
    }
}

public struct Nationality: Codable {
    public var country_code: String
    public var nation: String
    public var subdivision: String?
    
    enum CodingKeys: String, CodingKey {
        case country_code, 
             nation,
             subdivision
    }
}
