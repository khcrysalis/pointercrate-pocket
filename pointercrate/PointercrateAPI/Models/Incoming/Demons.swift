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
    /// Demon position on the list
    public var position: Int
    /// Demon name
    public var name: String
    /// Demon list percentage requirement
    public var requirement: Int
    /// Demon verification video
    public var video: String?
    /// Demon thumbnail URL
    public var thumbnail: String?
    /// Demon publisher based on geometry dash account
    public var publisher: Player
    /// Demon verifier, i.e. person who has beated and 'verified' the level to be uploaded to the gd servers
    public var verifier: Player
    /// Demon in-game level identifier
    public var level_id: Int?
    /// Demon makers
    public var creators: [Player]?
    /// Demon records, not present always
    public var records: [RecordListing]?
    
    enum CodingKeys: String, CodingKey {
        case id,
             name,
             position,
             requirement,
             video,
             thumbnail,
             publisher,
             verifier,
             level_id,
             creators,
             records
    }
}

