//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/08/2024.
//

import Foundation
import CoenttbHTML

public struct HotjarHead: HTML {
    let id: String
    let website: URL?
    
    public init(
        id: String,
        website: URL?
    ) {
        self.id = id
        self.website = website
    }
    
    public var body: some HTML {
        HTMLRaw(#"""
        <!-- Hotjar Tracking Code for \#(website?.absoluteString ?? "") -->
        <script>
            (function(h,o,t,j,a,r){
                h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
                h._hjSettings={hjid:\#(id),hjsv:6};
                a=o.getElementsByTagName('head')[0];
                r=o.createElement('script');r.async=1;
                r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
                a.appendChild(r);
            })(window,document,'https://static.hotjar.com/c/hotjar-','.js?sv=');
        </script>
        """#)
    }
}
