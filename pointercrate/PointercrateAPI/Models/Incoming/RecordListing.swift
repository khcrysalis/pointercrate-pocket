//
//  RecordListing.swift
//  pointercrate
//
//  Created by samara on 3/25/24.
//

import Foundation

public struct RecordListing: Codable {
    /// Record ID
    public var id: Int
    /// Record demon progress (max 100)
    public var progress: Int
    /// Record proof recording
    public var video: String?
    /// Record status
    public var approved: String?
    /// Demon thats associated with record
    public var demon: Demon?
    /// Player who've submitted record
    public var player: Player
    /// Nationality of said player
    public var nationality: Nationality?
    
    enum CodingKeys: String, CodingKey {
        case id,
             progress,
             video,
             approved,
             demon,
             player,
             nationality
    }
}
