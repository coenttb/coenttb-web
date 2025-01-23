//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 23/12/2024.
//

import Dependencies
import Foundation
import Foundation
import IssueReporting

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {
    public struct Handler<ResponseType: Decodable>: Sendable {
        private let closure: @Sendable (URLRequest, ResponseType.Type) async throws -> ResponseType
        
        public func callAsFuntion(
            for request: URLRequest,
            decodingTo type: ResponseType.Type
        ) async throws -> ResponseType {
            try await closure(request, type)
        }
    }
}

extension URLRequest.Handler: DependencyKey {
    public static var testValue: Self { .init(closure: { try await handleRequest(for: $0, decodingTo: $1, debug: true) }) }
    public static var liveValue: Self { .init(closure: { try await handleRequest(for: $0, decodingTo: $1, debug: false) }) }
}

@Sendable
public func handleRequest<ResponseType: Decodable>(
    for request: URLRequest,
    decodingTo type: ResponseType.Type,
    debug: Bool = {
#if DEBUG
        return true
#else
        return false
#endif
    }()
) async throws -> ResponseType {
    @Dependency(\.defaultSession) var session
    
    if debug {
        print("\n🌐 Request Details:")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        print("Headers:")
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                if key.lowercased() == "authorization" {
                    print("  \(key): *****")
                } else {
                    print("  \(key): \(value)")
                }
            }
        }
        if let body = request.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "Unable to decode body")")
        }
    }
    
    let (data, response) = try await session(request)
    
    if debug {
        print("\n📥 Response Details:")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers:")
            for (key, value) in httpResponse.allHeaderFields {
                print("  \(key): \(value)")
            }
        }
        print("Body: \(String(data: data, encoding: .utf8) ?? "Unable to decode response body")")
    }
    
    guard let httpResponse = response as? HTTPURLResponse else {
        let error = RequestError.invalidResponse
        if debug {
            print("\n❌ Error: Invalid Response")
            print("Expected HTTPURLResponse but got: \(String(describing: response))")
        }
        throw error
    }
    
    guard (200...299).contains(httpResponse.statusCode) else {
        let errorMessage: String
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
            errorMessage = errorResponse.message
        } else {
            errorMessage = String(decoding: data, as: UTF8.self)
        }
        
        let error = RequestError.httpError(
            statusCode: httpResponse.statusCode,
            message: errorMessage
        )
        
        if debug {
            print("\n❌ HTTP Error:")
            print("Status Code: \(httpResponse.statusCode)")
            print("Error Message: \(errorMessage)")
            print("Raw Response: \(String(data: data, encoding: .utf8) ?? "Unable to decode error response")")
        }
        
        throw error
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    } catch {
        if debug {
            print("\n❌ Decoding Error:")
            print("Error: \(error)")
            print("Raw Data: \(String(data: data, encoding: .utf8) ?? "Unable to show raw data")")
            
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print("JSON Structure:")
                print(json)
            }
        }
        reportIssue(error)
        throw error
    }
}

struct ErrorResponse: Decodable {
    let message: String
}


public enum RequestError: LocalizedError, Equatable {
    case invalidResponse
    case httpError(statusCode: Int, message: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode, let message):
            return "HTTP error \(statusCode): \(message)"
        }
    }
}




