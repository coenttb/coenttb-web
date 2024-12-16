//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/08/2024.
//

import Foundation
import CoenttbHTML

public struct GoogleAnalyticsHead: HTML {
    let id: String
    
    public init(id: String) {
        self.id = id
    }
    
    public var body: some HTML {
        HTMLRaw(#"""
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=\#(id)"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', '\#(id)');
        </script>
        """#)
    }
}
