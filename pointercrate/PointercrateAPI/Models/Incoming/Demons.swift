//
//  AllDemons.swift
//  pointercrate
//
//  Created by samara on 3/23/24.
//

import Foundation

public struct Demons: Codable {
    /// Demon identifier
    public var id: Int
    /// Demon name
    public var position: Int
    /// Demon list percentage requirement
    public var name: String
    /// Demon position on the list
    public var requirement: Int
    /// Demon verification video
    public var video: String?
    /// Demon thumbnail URL
    public var thumbnail: String?
    /// Demon publisher based on geometry dash account
    public var publisher: Publisher
    /// Demon verifier, i.e. person who has beated and 'verified' the level to be uploaded to the gd servers
    public var verifier: Verifier
    /// Demon in-game level identifier
    public var level_id: Int?
    
    enum CodingKeys: String, CodingKey {
        case id,
             name,
             position,
             requirement,
             video,
             thumbnail,
             publisher,
             verifier,
             level_id
    }
}

public struct Publisher: Codable {
    public var id: Int
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case id,
             name
    }
}

public struct Verifier: Codable {
    public var id: Int
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case id,
             name
    }
}
