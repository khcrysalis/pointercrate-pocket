//
//  Demons.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation

public struct RankedDemons: Codable {
    /// Demon identifier
    public var id: Int
    /// Demon name
    public var name: String
    /// Demon position on the list
    public var position: Int
    /// Demon list percentage requirement
    public var requirement: Int
    /// Demon verification video
    public var video: String
    /// Demon publisher based on geometry dash account
    public var publisher: Publisher
    /// Demon verifier, i.e. person who has beated and 'verified' the level to be uploaded to the gd servers
    public var verifier: Verifier
   // public var creators: [Creator]
    
    enum CodingKeys: String, CodingKey {
        case id, 
             name,
             position,
             requirement,
             video,
             publisher,
             verifier
             //creators
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

public struct Creator: Codable {
    public var id: Int
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case id, 
             name
    }
}
