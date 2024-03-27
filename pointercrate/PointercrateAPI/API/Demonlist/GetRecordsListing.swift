//
//  GetRecordsListing.swift
//  pointercrate
//
//  Created by samara on 3/25/24.
//

import Foundation

extension PointercrateAPI {
    /// https://pointercrate.com/documentation/records#get-records
    public func getRecordsListing(id: Int? = nil,
                                  progress: Int? = nil,
                                  progressGreaterThan: Int? = nil,
                                  progressLessThan: Int? = nil,
                                  status: String? = nil,
                                  player: String? = nil,
                                  video: String? = nil,
                                  demon: String? = nil,
                                  demon_position: Int? = nil,
                                  demon_position_greaterThan: Int? = nil,
                                  demon_position_lessThan: Int? = nil,
                                  demon_id: Int? = nil,
                                  submitter: Int? = nil,
                                  limit: Int? = nil,
                                  after: Int? = nil,
                                  before: Int? = nil
    ) async throws -> [RecordListing]
    {
        let queryItems: [URLQueryItem?] = [
            id.map { URLQueryItem(name: "id", value: String($0)) },
            progress.map { URLQueryItem(name: "progress", value: String($0)) },
            progressGreaterThan.map { URLQueryItem(name: "progress__gt", value: String($0)) },
            progressLessThan.map { URLQueryItem(name: "progress__lt", value: String($0)) },
            status.map { URLQueryItem(name: "status", value: $0) },
            player.map { URLQueryItem(name: "player", value: $0) },
            video.map { URLQueryItem(name: "video", value: $0) },
            demon.map { URLQueryItem(name: "demon", value: $0) },
            demon_position.map { URLQueryItem(name: "demon_position", value: String($0)) },
            demon_position_greaterThan.map { URLQueryItem(name: "demon_position__gt", value: String($0)) },
            demon_position_lessThan.map { URLQueryItem(name: "demon_position__lt", value: String($0)) },
            demon_id.map { URLQueryItem(name: "demon_id", value: String($0)) },
            submitter.map { URLQueryItem(name: "submitter", value: String($0)) },
            limit.map { URLQueryItem(name: "limit", value: String($0)) },
            after.map { URLQueryItem(name: "after", value: String($0)) },
            before.map { URLQueryItem(name: "before", value: String($0)) }
        ]
        
        let compactQueryItems = queryItems.compactMap { $0 }
        
        return try await getReq(path: "/v1/records/", query: compactQueryItems)
    }
}
