//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/09/2024.
//

import Foundation
import CoenttbHTML


extension HTML {
    @HTMLBuilder
    public func focusOnPageLoad() -> some HTML {
        let focusClass = "focus-on-load-\(UUID().uuidString)"
        
        HTMLGroup {
            self.class(focusClass)
            
            script {"""
            document.addEventListener('DOMContentLoaded', function() {
                const elements = document.getElementsByClassName('\(focusClass)');
                if (elements.length > 0) {
                    elements[0].focus();
                }
            });
            """}
        }
    }
}
