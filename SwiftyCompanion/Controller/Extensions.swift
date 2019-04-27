//
//  Extensions.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/12/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

extension UIViewController {
    func assignBackground(background: String){
        let background = UIImage(named: background)
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }

}
extension UIColor {
    public typealias RGB = (r: UInt, g: UInt, b: UInt)
    public convenience init(rgb: RGB, alpha: CGFloat = 1.0) {
        self.init(
            red:   CGFloat(rgb.r)/255.0,
            green: CGFloat(rgb.g)/255.0,
            blue:  CGFloat(rgb.b)/255.0,
            alpha: alpha
        )
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


extension UserViewController {
    
    func clearImageFromCache() {
        let URL = NSURL(string: getUserInfo.student!.image_url!)!
        let URLRequest = NSURLRequest(url: URL as URL)
        let imageDownloader = UIImageView.af_sharedImageDownloader
        
        // Clear the URLRequest from the in-memory cache
        let _ = imageDownloader.imageCache?.removeImage(for: URLRequest as URLRequest, withIdentifier: nil)
        
        // Clear the URLRequest from the on-disk cache
        imageDownloader.sessionManager.session.configuration.urlCache?.removeCachedResponse(for: URLRequest as URLRequest)
    }
    
    func setupLayout() {
        infoView.layer.cornerRadius = 5.0
        progressBar.layer.cornerRadius = 5.0
        progressBar.layer.borderWidth = 1.0
        progressBarL.layer.borderWidth = 1.0
        infoView.layer.borderWidth = 1.0
        image.layer.borderWidth = 1.5
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.black.cgColor
        
        setupProgressBar()
        setupLabels()
    }
    
    func setupLabels() {
        userName.text = getUserInfo.student?.displayname!
        userName.adjustsFontSizeToFitWidth = true
        if let x = getUserInfo.student?.location {
            location.text = x
            isAvailable.text = "Available"
        }
        else {
            location.text = "-"
            isAvailable.text = "Unavailable"
        }
    }
    
    func setupProgressBar() {
        progressBarL.layer.cornerRadius = 4.0
        if let level = cursus?.level {
            let trimmedLevel  = 0 + level.truncatingRemainder(dividingBy: 1)
            levelIndicator.text = "level " + String(level) + "%"
            progressBarL.widthAnchor.constraint(equalTo: progressBar.widthAnchor, multiplier: CGFloat(trimmedLevel)).isActive = true
        }
        else{
            progressBarL.widthAnchor.constraint(equalTo: progressBar.widthAnchor, multiplier: 0).isActive = true
            levelIndicator.text = "0.0%"
        }
//        progressBarL.backgroundColor = .clear
        progressBarColor()
    }
    
    func progressBarColor() {
        switch getUserInfo.coas! {
        case "federation":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:65, g:128, b:219))
        case "assembly":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:160, g:97, b:209))
        case "order":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:255, g:105, b:80))
        case "alliance":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:51, g:196, b:127))
        case "worms":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:234, g:183, b:127))
        case "sloths":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:255, g:169, b:198))
        case "skunks":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:108, g:137, b:70))
        case "blobfishes":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:130, g:204, b:224))
        case "allianceK":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:76, g:175, b:80))
        case "unionK":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:103, g:58, b:183))
        case "empireK":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:244, g:67, b:54))
        case "hiveK":
            progressBarL.backgroundColor = UIColor(rgb: UIColor.RGB(r:0, g:188, b:212))
        default:
            break
        }
    }
}


extension UIImageView {
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    public func loadGif(url: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(url: url)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}

extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        return gif(data: dataAsset.data)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}
