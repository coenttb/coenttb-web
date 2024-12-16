//
//  RequestTimer.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 13/12/2024.
//

import Foundation


struct RequestTimer {
    private let startTime: DispatchTime
    
    init() {
        self.startTime = DispatchTime.now()
    }
    
    var milliseconds: Int64 {
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - startTime.uptimeNanoseconds
        return Int64(nanoTime) / 1_000_000 // Convert nanoseconds to milliseconds
    }
    
    var microseconds: Int64 {
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - startTime.uptimeNanoseconds
        return Int64(nanoTime) / 1_000 // Convert nanoseconds to microseconds
    }
}
