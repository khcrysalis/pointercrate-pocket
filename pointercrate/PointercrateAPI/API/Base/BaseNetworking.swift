//
//  BaseNetworking.swift
//  pointercrate
//
//  Created by samara on 3/20/24.
//

import Foundation
import CryptoKit

/// Utility wrappers for making requests quickly
extension PointercrateAPI {
	enum RequestError: Error {
		case missingRequestHeaders(context: String)
		case unexpectedResponseCode(_ code: Int)
		case invalidResponse
		case jsonDecodingError(error: Error) // This is not strongly typed because it was simpler to just use one catch
		case genericError(reason: String)
	}
	
	public
	enum RequestMethod: String {
		case get = "GET"
		case post = "POST"
		case delete = "DELETE"
	}
	
	/// Make a REST API request
	///
	/// Low level method for API requests, meant to be as generic
	/// as possible. You should call other wrapper methods like `getReq()`,
	/// `postReq()`, `deleteReq()`, etc. where possible instead.
	///
	/// - Parameters:
	///   - path: API endpoint path relative to `GatewayConfig.restBase`
	///   - query: Array of URL query items
	///   - body: Request body, should be a JSON string
	///   - method: Method for the request
	///   (currently `.get`, `.post`, `.delete` or `.patch`)
	///   - headers: Headers to set (overrides any automatically set headers)
	///   - baseURL: Custom base URL to contact
	///   - useAuth: Controls whether Authorization headers are used
	///
	/// - Returns: Raw `Data` of response, or nil if the request failed
	func makeRequest(
		path: String,
		query: [URLQueryItem] = [],
		body: Data? = nil,
		method: RequestMethod = .get,
		headers: [String: String] = [:],
		baseURL: URL = PointercrateAPIConfig.default.baseURL,
		useAuth: Bool
	) async throws -> Data {
		let apiURL = baseURL.appendingPathComponent(path, isDirectory: false)
		
		var headers = headers
		
		if useAuth, let token = Self.auth.accessToken {
			headers["Authorization"] = "Basic \(token)"
		} else {
			if useAuth { print("[PointercrateAPIConfig] Couldn't find token data") }
		}
		
		headers["host"] = baseURL.host
		
		// Add query params (if any)
		var urlBuilder = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)!
		urlBuilder.queryItems = query
		let reqURL = urlBuilder.url!
		
		// Create URLRequest and set headers
		var req = URLRequest(url: reqURL)
		req.httpMethod = method.rawValue
		
		// specified header overrides
		for (key, value) in headers {
			req.setValue(value, forHTTPHeaderField: key)
		}
		
		if let body {
			req.httpBody = body
		}
		// Make request
		guard let (data, response) = try? await PointercrateAPI.session.data(for: req),
			  let httpResponse = response as? HTTPURLResponse else {
			throw RequestError.invalidResponse
		}
		
		guard httpResponse.statusCode / 100 == 2 else { // Check if status code is 2**
			print("[PointercrateAPIConfig Error] Response status code \(httpResponse.statusCode) for \(req)\n\(String(decoding: data, as: UTF8.self))")
			throw RequestError.unexpectedResponseCode(httpResponse.statusCode)
		}
		
		return data
	}
	
	/// Make a REST API request but with a URL
	///
	/// Low level method for API requests, meant to be as generic
	/// as possible. You should call other wrapper methods like `getReq()`,
	/// `postReq()`, `deleteReq()`, etc. where possible instead.
	///
	/// - Parameters:
	///   - url: URL to contact
	///   - body: Request body, should be a JSON string
	///   - method: Method for the request
	///   (currently `.get`, `.post`, `.delete` or `.patch`)
	///   - headers: Headers to set (overrides any automatically set headers)
	///   - baseURL: Custom base URL to contact
	///   - useAuth: Controls whether Authorization headers are used
	///
	/// - Returns: Raw `Data` of response, or nil if the request failed
	func makeRequest(
		url: URL,
		body: Data? = nil,
		method: RequestMethod = .get,
		headers: [String: String] = [:],
		useAuth: Bool
	) async throws -> Data {
		let apiURL = url
		
		var headers = headers
		
		if useAuth, let token = Self.auth.accessToken {
			headers["Authorization"] = "Basic \(token)"
		} else {
			if useAuth { print("[PointercrateAPIConfig] Couldn't find token data") }
		}
		
		headers["host"] = apiURL.host
		
		// Add query params (if any)
		var urlBuilder = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)!
		let reqURL = urlBuilder.url!
		
		// Create URLRequest and set headers
		var req = URLRequest(url: reqURL)
		req.httpMethod = method.rawValue
		
		// specified header overrides
		for (key, value) in headers {
			req.setValue(value, forHTTPHeaderField: key)
		}
		
		if let body {
			req.httpBody = body
		}
		// Make request
		guard let (data, response) = try? await PointercrateAPI.session.data(for: req),
			  let httpResponse = response as? HTTPURLResponse else {
			throw RequestError.invalidResponse
		}
		
		guard httpResponse.statusCode / 100 == 2 else { // Check if status code is 2**
			print("[PointercrateAPIConfig Error] Response status code \(httpResponse.statusCode) for \(req)\n\(String(decoding: data, as: UTF8.self))")
			throw RequestError.unexpectedResponseCode(httpResponse.statusCode)
		}
		
		return data
	}
	
	/// Make a `GET` request to the REST API
	///
	/// Wrapper method for `makeRequest()` to make a GET request.
	///
	/// - Parameters:
	///   - path: API endpoint path relative to `PointercrateAPIConfigConfig.baseURL`
	///  (passed canonically to `makeRequest()`)
	///   - query: Array of URL query items (passed canonically to `makeRequest()`)
	///
	/// - Returns: Struct of response conforming to Decodable, or nil
	/// if the request failed or the response couldn't be JSON-decoded.
	func getReq<T: Decodable>(
		path: String,
		query: [URLQueryItem] = [],
		headers: [String: String] = [:],
		useAuth: Bool = true
	) async throws -> T {
		// This helps debug JSON decoding errors
		let respData = try await makeRequest(path: path, query: query, headers: headers, useAuth: useAuth)
		do {
			return try PointercrateAPI.decoder.decode(T.self, from: respData)
		} catch {
			throw RequestError.jsonDecodingError(error: error)
		}
	}
	
	/// Make a `POST` request to the REST API
	func postReq<D: Decodable, B: Encodable>(
		path: String,
		body: B? = nil,
		useAuth: Bool = true
	) async throws -> D {
		let payload = body != nil ? try PointercrateAPI.encoder.encode(body) : nil
		let respData = try await makeRequest(
			path: path,
			body: payload,
			method: .post,
			useAuth: useAuth
		)
		do {
			return try PointercrateAPI.decoder.decode(D.self, from: respData)
		} catch {
			throw RequestError.jsonDecodingError(error: error)
		}
	}
	
	/// Make a `POST` request to the REST API with raw data
	func postReq<D: Decodable>(
		path: String,
		data: Data? = nil,
		headers: [String: String] = [:],
		useAuth: Bool = true
	) async throws -> D {
		let respData = try await makeRequest(
			path: path,
			body: data,
			method: .post,
			headers: headers,
			useAuth: useAuth
		)
		do {
			return try PointercrateAPI.decoder.decode(D.self, from: respData)
		} catch {
			throw RequestError.jsonDecodingError(error: error)
		}
	}
	
	/// Make a `POST` request to the REST API with raw data
	///
	/// For endpoints that returns a 204 empty response
	func postReq(
		path: String,
		data: Data? = nil,
		headers: [String: String] = [:],
		useAuth: Bool = true
	) async throws {
		let _ = try await makeRequest(
			path: path,
			body: data,
			method: .post,
			headers: headers,
			useAuth: useAuth
		)
	}
	
	/// Make a `POST` request to the REST API
	///
	/// For endpoints that returns a 204 empty response
	func postReq<B: Encodable>(
		path: String,
		body: B,
		useAuth: Bool = true
	) async throws {
		let payload = try PointercrateAPI.encoder.encode(body)
		_ = try await makeRequest(
			path: path,
			body: payload,
			method: .post,
			useAuth: useAuth
		)
	}
	
	/// Make a `POST` request to the REST API, for endpoints
	/// that both require no payload and returns a 204 empty response
	func postReq(path: String, useAuth: Bool = true) async throws {
		_ = try await makeRequest(
			path: path,
			body: nil,
			method: .post,
			useAuth: useAuth
		)
	}
	
	/// Make a `DELETE` request to the REST API
	func deleteReq(path: String, useAuth: Bool = true) async throws {
		_ = try await makeRequest(path: path, method: .delete, useAuth: useAuth)
	}
}





extension PointercrateAPI {
	public static let encoder: JSONEncoder = {
		let enc = JSONEncoder()
		enc.dateEncodingStrategy = .iso8601
		return enc
	}()
	public static let decoder: JSONDecoder = {
		let dec = JSONDecoder()
		dec.dateDecodingStrategy = .iso8601
		return dec
	}()
}
