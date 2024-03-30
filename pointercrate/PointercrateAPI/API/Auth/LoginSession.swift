//
//  LoginSession.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation

extension PointercrateAPI {
  /// Keeps track of the login session
  public class Session: ObservableObject {
    init() {}
    
    @CodableStorage(key: "PointercrateAPI.AuthStorage", defaultValue: nil)
    public var storage: AuthResponse?
    
    public var user: User? {
      self.storage?.user
    }
    
    internal var accessToken: String? {
      self.storage?.token
    }
    
    public var isLoggedIn: Bool {
      self.storage != nil
    }
    
    public func populate(with data: AuthResponse) {
      self.storage = data
      self.objectWillChange.send()
    }
    
    public func destroy() {
      self.storage = nil
      self.objectWillChange.send()
    }
  }
}
