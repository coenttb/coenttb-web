//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 10/12/2024.
//

import Foundation
import Dependencies
import DependenciesMacros
import Date

@DependencyClient
public struct Client: @unchecked Sendable {
    @DependencyEndpoint
    public var getAll: () -> [Blog.Post] = { [] }
    
    @DependencyEndpoint
    public var filenameToResourceUrl: (String) -> URL? = { _ in nil }
    
    @DependencyEndpoint
    public var postToRoute: (Blog.Post) -> URL? = { _ in nil }
    
    @DependencyEndpoint
    public var postToFilename: (Blog.Post) -> TranslatedString = { _ in .init("") }
}

import CoenttbWebHTML

public enum BlogKey {
    
}


extension BlogKey: TestDependencyKey {
    public static let testValue: CoenttbWebBlog.Client = .init(
        getAll: {
            [
                .preview
            ]
        },
        filenameToResourceUrl: { fileName in
            Bundle.module.url(forResource: fileName, withExtension: "md")
        },
        postToRoute: { post in
            nil
        },
        postToFilename: { post in
                        
            return TranslatedString { language in
                
                let baseName = "Blog-\(post.index)"
                
                let previewBaseName = "Preview-Blog-\(post.index)"
                
                return (post.hidden == .preview ? previewBaseName : baseName) + "-\(language.rawValue)"
                
            }
        }
    )
}

extension Client {
    public func urlForPost(post: Blog.Post) -> Translated<URL?> {
        self
            .postToFilename(post)
            .map(self.filenameToResourceUrl)
    }
}

extension DependencyValues {
    public var blog: CoenttbWebBlog.Client {
        get { self[BlogKey.self] }
        set { self[BlogKey.self] = newValue }
    }
}
