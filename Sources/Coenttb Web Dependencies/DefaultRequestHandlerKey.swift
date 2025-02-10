//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 23/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
import Coenttb_Web_Models

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif



extension URLRequest {
    public struct Handler: Sendable {
        var debug = false
        
        @_disfavoredOverload
        public func callAsFunction<ResponseType: Codable>(
            for request: URLRequest,
            decodingTo type: ResponseType.Type,
            fileID: StaticString = #fileID,
            filePath: StaticString = #filePath,
            line: UInt = #line,
            column: UInt = #column
        ) async throws -> ResponseType {
            let (data, _) = try await performRequest(request)
            do {
                return try decodeResponse(
                    data: data,
                    as: type,
                    fileID: fileID,
                    filePath: filePath,
                    line: line,
                    column: column
                )
            }
            catch {
                let response = try decodeResponse(
                    data: data,
                    as: Envelope<ResponseType>.self,
                    fileID: fileID,
                    filePath: filePath,
                    line: line,
                    column: column
                )
                
                guard let data = response.data else { throw URLError(.cannotDecodeRawData) }
                return data
            }
        }
        
        // For Void requests
        public func callAsFunction(
            for request: URLRequest
        ) async throws {
            let (_, _) = try await performRequest(request)
        }
        
        private func performRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
            if debug { logRequest(request) }
            
            @Dependency(\.defaultSession) var session
            let (data, response) = try await session(request)
            
            if debug { logResponse(response, data: data) }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                if debug {
                    print("\n❌ Error: Invalid Response")
                    print("Expected HTTPURLResponse but got: \(String(describing: response))")
                }
                throw RequestError.invalidResponse
            }
            
            try validateResponse(httpResponse, data: data)
            return (data, httpResponse)
        }
        
        private func decodeResponse<T: Decodable>(
            data: Data,
            as type: T.Type,
            fileID: StaticString = #fileID,
            filePath: StaticString = #filePath,
            line: UInt = #line,
            column: UInt = #column
        ) throws -> T {
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
                reportIssue(
                    error,
                    fileID: fileID,
                    filePath: filePath,
                    line: line,
                    column: column
                )
                throw error
            }
        }
        
        private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
            guard (200...299).contains(response.statusCode) else {
                let errorMessage = (try? JSONDecoder().decode(ErrorResponse.self, from: data).message)
                ?? String(decoding: data, as: UTF8.self)
                
                let error = RequestError.httpError(
                    statusCode: response.statusCode,
                    message: errorMessage
                )
                
                if debug {
                    print("\n❌ HTTP Error:")
                    print("Status Code: \(response.statusCode)")
                    print("Error Message: \(errorMessage)")
                    print("Raw Response: \(String(data: data, encoding: .utf8) ?? "Unable to decode error response")")
                }
                
                throw error
            }
        }
        
        private func logRequest(_ request: URLRequest) {
            print("\n🌐 Request Details:")
            print("URL: \(request.url?.absoluteString ?? "nil")")
            print("Method: \(request.httpMethod ?? "nil")")
            print("Headers:")
            request.allHTTPHeaderFields?.forEach { key, value in
                print("  \(key): \(key.lowercased() == "authorization" ? "*****" : value)")
            }
            if let body = request.httpBody {
                print("Body: \(String(data: body, encoding: .utf8) ?? "Unable to decode body")")
            }
        }
        
        private func logResponse(_ response: URLResponse, data: Data) {
            print("\n📥 Response Details:")
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                print("Headers:")
                httpResponse.allHeaderFields.forEach { key, value in
                    print("  \(key): \(value)")
                }
            }
            print("Body: \(String(data: data, encoding: .utf8) ?? "Unable to decode response body")")
        }
    }
}

extension DependencyValues {
    public var defaultRequestHandler: URLRequest.Handler {
        get { self[URLRequest.Handler.self] }
        set { self[URLRequest.Handler.self] = newValue }
    }
}

extension URLRequest.Handler: DependencyKey {
    public static var testValue: Self { .init(debug: true) }
    public static var liveValue: Self { .init(debug: false) }
}

struct ErrorResponse: Decodable {
    let message: String
}

public enum RequestError: Sendable, LocalizedError, Equatable {
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


