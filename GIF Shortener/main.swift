//
//  main.swift
//  GIF Shortener
//
//  Created by Erik Little on 1/6/15.
//

import Foundation

var running = 0
var delay = 0.01 as Float

for i in 1..<C_ARGC {
    let index = Int(i)
    if let arg = String.fromCString(C_ARGV[index]) {
        
        // Skip the delay
        if ((arg as NSString).floatValue != 0) {
            continue
        }
        
        if (arg == "-d") {
            if let del = String.fromCString(C_ARGV[index + 1]) {
                delay = (del as NSString).floatValue
                continue
            }
        }
        
        running++
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            let short = Shortener(path: arg)
            short.shorten(perFrameDelay: delay)
        }
    }
}

CFRunLoopRun()
