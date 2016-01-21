//
//  Shortener.swift
//  GIF Shortener
//
//  Created by Erik Little on 1/6/15.
//

import Foundation
import ImageIO

class Shortener {
    let path:NSURL!
    
    init(path pathAsString:String) {
        self.path = NSURL(fileURLWithPath: pathAsString)
    }
    
    func shorten(perFrameDelay perFrameDelay:Float) {
        
        let source = CGImageSourceCreateWithURL(self.path, nil)!
        let prop = CGImageSourceCopyProperties(source, nil) as NSDictionary?
        if prop != nil {
            var images = [CGImage]()
            let numberOfFrames = CGImageSourceGetCount(source)
            let gifProp = [
                "{GIF}": [
                    "DelayTime": perFrameDelay,
            ]]
            
            // add each frame to images
            for i in 0..<numberOfFrames {
                let image = CGImageSourceCreateImageAtIndex(source, i, nil)
                images.append(image!)
            }
            
            let dest = CGImageDestinationCreateWithURL(self.path, kUTTypeGIF, numberOfFrames, nil)
            
            // Add back the properties for the GIF
            CGImageDestinationSetProperties(dest!, prop)
            
            // Change the delay for each frame
            for i in 0..<images.count {
                CGImageDestinationAddImage(dest!, images[i], gifProp)
            }
            
            // Create the new image
            CGImageDestinationFinalize(dest!)
            running--
            
            if (running == 0) {
                exit(0)
            }
        } else {
            fatalError("Something went wrong")
        }
    }
}