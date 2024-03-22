//
//  Config.swift
//  pointercrate
//
//  Created by samara on 3/20/24.
//

import Foundation
import CryptoKit

public struct PointercrateAPIConfig {
    public static let `default` = {
        
        let lang = Locale.current.identifier
        
        var headers = [
            "Accept-Language": lang,
            "App-OS": "Android",
            "App-OS-Version": "Android 10.0",
            "App-Version": "1.0",
            "Referer": "https://pointercrate.com"
        ]
        headers["User-Agent"] = "PointercrateApp/\(headers["App-Version"]!) (\(headers["App-OS-Version"]!); Pixel C)"
        
        return PointercrateAPIConfig(
            baseURL: URL(string: "https://pointercrate.com/api")!,
            _headers: headers
        )
    }()
    
    public let baseURL: URL
    private let _headers: [String: String]
    
    public var headers: [String: String] {
        var egg = self._headers
        
        let localTime = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+00:00"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter.string(from: Date())
        }()
        egg["x-client-time"] = localTime
        
        return egg
    }
}
