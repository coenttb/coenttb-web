//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 13/08/2024.
//

import Dependencies
import Foundation
import CoenttbHTML
import CoenttbMarkdown
import Languages

public struct Clause<Content: HTML>: HTML {
    let index: Int?
    let header: String?
    let content: Content
    
    public init(
        index: Int? = nil,
        header: String?,
        @HTMLBuilder content: () -> Content
    ) {
        self.index = index
        self.header = header
        self.content = content()
    }
    
    public var body: some HTML {
        
        let head: some HTML = HTMLGroup {
            switch (index, header) {
            case let (.some(index), .some(header)):
                Header(4) { "\(index). \(header)" }
            case let (.none, .some(header)):
                Header(4) { "\(header)" }
            case let (.some(index), .none):
                Header(4) { "\(index)" }
            case (.none, .none):
                HTMLEmpty()
            }
        }
        
        return HTMLGroup {
            head
            content
        }
    }
}

public struct Clauses: HTML, ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: (header: String?, content: any HTML)...) {
        self.clauses = elements
    }

    let clauses: [(header: String?, content: any HTML)]
    
    public init(_ clauses: [(header: String?, content: any HTML)]) {
        self.clauses = clauses
    }
    
    public var body: some HTML {
        HTMLForEach(self.clauses.enumerated().map { $0 }) { index, clause in
            Clause(index: index + 1, header: clause.header) {
                AnyHTML(clause.content)
            }
        }
    }
}

