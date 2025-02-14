import Dependencies
import Foundation
import IssueReporting
import Coenttb_Web_Models

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {
    public struct Handler: Sendable {
        public var debug = false
        
        public func callAsFunction<ResponseType: Decodable>(
            for request: URLRequest,
            decodingTo type: ResponseType.Type,
            fileID: StaticString = #fileID,
            filePath: StaticString = #filePath,
            line: UInt = #line,
            column: UInt = #column
        ) async throws -> ResponseType {
            let (data, _) = try await performRequest(request)
            
            if debug {
                print("\nTrying to decode response data:")
                print(String(data: data, encoding: .utf8) ?? "Unable to decode response data")
            }
            
            // First try to decode as Envelope
            do {
                if debug { print("\nAttempting to decode as Envelope<\(String(describing: ResponseType.self))>") }
                
                let envelope = try decodeResponse(
                    data: data,
                    as: Envelope<ResponseType>.self,
                    fileID: fileID,
                    filePath: filePath,
                    line: line,
                    column: column
                )
                
                if debug { print("\nEnvelope decoded successfully. Success: \(envelope.success)") }
                
                if let envelopeData = envelope.data {
                    if debug { print("\nReturning envelope data") }
                    return envelopeData
                }
                
                if debug { print("\nEnvelope data is nil, trying direct decode") }
                throw URLError(.cannotDecodeRawData)
            } catch {
                if debug {
                    print("\nEnvelope decode failed, attempting direct decode")
                    print("Error was: \(error)")
                }
                
                // If envelope decode fails, try direct decode
                do {
                    let response = try decodeResponse(
                        data: data,
                        as: type,
                        fileID: fileID,
                        filePath: filePath,
                        line: line,
                        column: column
                    )
                    
                    if debug { print("\nDirect decode successful") }
                    return response
                } catch let decodeError {
                    if debug { print("\nDirect decode failed: \(decodeError)") }
                    throw decodeError
                }
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
            decoder: JSONDecoder = {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return decoder
            }(),
            fileID: StaticString = #fileID,
            filePath: StaticString = #filePath,
            line: UInt = #line,
            column: UInt = #column
        ) throws -> T {
            do {
                return try decoder.decode(type, from: data)
            } catch {
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
                    print(String(reflecting: error))
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

public enum RequestError: Error, Equatable {
    case invalidResponse
    case httpError(statusCode: Int, message: String)
    
    public var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode, let message):
            return "HTTP error \(statusCode): \(message)"
        }
    }
}
