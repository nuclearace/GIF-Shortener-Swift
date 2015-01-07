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
    
    func shorten(perFrameDelay:Float = 0.01) {
        
        let source = CGImageSourceCreateWithURL(self.path, nil)
        let prop = CGImageSourceCopyProperties(source, nil) as NSDictionary
        
        if let gif = prop["{GIF}"] as? NSDictionary {
            var images = [CGImage]()
            var imagesProps = [NSDictionary]()
            let numberOfFrames = CGImageSourceGetCount(source)
            let gifProp = [
                "{GIF}": [
                    "DelayTime": perFrameDelay,
            ]]
            
            // add each frame to images
            for i in 0..<numberOfFrames {
                imagesProps.append(CGImageSourceCopyPropertiesAtIndex(source, i, nil))
                let image = CGImageSourceCreateImageAtIndex(source, i, nil)
                images.append(image)
            }
            
            let dest = CGImageDestinationCreateWithURL(self.path, kUTTypeGIF, numberOfFrames, nil)
            
            // Add back the properties
            CGImageDestinationSetProperties(dest, prop)
            
            for i in 0..<images.count {
                CGImageDestinationAddImage(dest, images[i], gifProp)
            }
            
            // Create the new image
            CGImageDestinationFinalize(dest)
            running--
            
            if (running == 0) {
                exit(0)
            }
        }
    }
}