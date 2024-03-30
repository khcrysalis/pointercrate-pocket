//
//  PointercrateAPI.swift
//  pointercrate
//
//  Created by samara on 3/20/24.
//

import Foundation

public class PointercrateAPI: ObservableObject {
    public static let shared = PointercrateAPI()
    
    public static let auth = Session()
    
    // specifically varget so that the session is recreated every time its needed
    // so that the additional headers can be updated
    public static var session: URLSession {
        // Create URL Session Configuration
        let configuration = URLSessionConfiguration.default
        
        configuration.httpAdditionalHeaders = PointercrateAPIConfig.default.headers
        
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.httpShouldSetCookies = true
        configuration.httpCookieAcceptPolicy = .always
        
        return URLSession(configuration: configuration)
    }
}
