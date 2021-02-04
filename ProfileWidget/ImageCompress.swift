//
//  ImageCompress.swift
//  ITIconThemePI
//
//  Created by JOJO on 2020/12/25.
//

import Foundation
import UIKit
import Accelerate.vImage

class WWImageCompress: NSObject {
    //压缩图片到指定大小
    // maxCount: Data size
    public static func compressWithMaxCount(origin:UIImage,maxCount:Int) -> Data? {
        
        var compression:CGFloat = 1
        
        guard var data = origin.jpegData(compressionQuality: compression) else { return nil }
        
        if data.count <= maxCount {
            
            return data
            
        }
        
        var max:CGFloat = 1,min:CGFloat = 0.8//最小0.8
        
        for i in 0...6 {//最多压缩6次
            
            compression = (max+min)/2
            
            if let tmpdata = origin.jpegData(compressionQuality: compression) {
                
                data = tmpdata
                
            } else {
                
                return nil
                
            }
            
            if data.count <= maxCount {
                
                return data
                
            } else {
                
                max = compression
                
            }
            
        }
        
        
        
        //压缩分辨率
        
        guard var resultImage = UIImage(data: data) else { return nil }
        
        var lastDataCount:Int = 0
        
        while data.count > maxCount && data.count != lastDataCount {
            
            lastDataCount = data.count
            
            let ratio = CGFloat(maxCount)/CGFloat(data.count)
            
            let size = CGSize(width: resultImage.size.width*sqrt(ratio), height: resultImage.size.height*sqrt(ratio))
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: CGFloat(Int(size.width)), height: CGFloat(Int(size.height))), true, 1)//防止黑边
            
            resultImage.draw(in: CGRect(origin: .zero, size: size))//比转成Int清晰
            
            if let tmp = UIGraphicsGetImageFromCurrentImageContext() {
                
                resultImage = tmp
                
                UIGraphicsEndImageContext()
                
            } else {
                
                UIGraphicsEndImageContext()
                
                return nil
                
            }
            
            if let tmpdata = resultImage.jpegData(compressionQuality: compression) {
                
                data = tmpdata
                
            } else {
                
                return nil
                
            }
            
        }
        
        return data
        
    }
        

    static  func resizedImage(at data: Data, for size: CGSize) -> UIImage? {
        
        // Decode the source image
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
              
              let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
              
              let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
              
              let imageWidth = properties[kCGImagePropertyPixelWidth] as? vImagePixelCount,
              
              let imageHeight = properties[kCGImagePropertyPixelHeight] as? vImagePixelCount
        
        else {
            
            return nil
            
        }
        
        
        
        // Define the image format
        
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          
                                          bitsPerPixel: 32,
                                          
                                          colorSpace: nil,
                                          
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          
                                          version: 0,
                                          
                                          decode: nil,
                                          
                                          renderingIntent: .defaultIntent)
        
        
        
        var error: vImage_Error
        
        
        
        // Create and initialize the source buffer
        
        var sourceBuffer = vImage_Buffer()
        
        defer { sourceBuffer.data.deallocate() }
        
        error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                             
                                             &format,
                                             
                                             nil,
                                             
                                             image,
                                             
                                             vImage_Flags(kvImageNoFlags))
        
        guard error == kvImageNoError else { return nil }
        
        
        
        // Create and initialize the destination buffer
        
        var destinationBuffer = vImage_Buffer()
        
        error = vImageBuffer_Init(&destinationBuffer,
                                  
                                  vImagePixelCount(size.height),
                                  
                                  vImagePixelCount(size.width),
                                  
                                  format.bitsPerPixel,
                                  
                                  vImage_Flags(kvImageNoFlags))
        
        guard error == kvImageNoError else { return nil }
        
        
        
        // Scale the image
        
        error = vImageScale_ARGB8888(&sourceBuffer,
                                     
                                     &destinationBuffer,
                                     
                                     nil,
                                     
                                     vImage_Flags(kvImageHighQualityResampling))
        
        guard error == kvImageNoError else { return nil }
        
        
        
        // Create a CGImage from the destination buffer
        
        guard let resizedImage =
                
                vImageCreateCGImageFromBuffer(&destinationBuffer,
                                              
                                              &format,
                                              
                                              nil,
                                              
                                              nil,
                                              
                                              vImage_Flags(kvImageNoAllocate),
                                              
                                              &error)?.takeRetainedValue(),
              
              error == kvImageNoError
        
        else {
            
            return nil
            
        }
        
        
        
        return UIImage(cgImage: resizedImage)
        
    }

    
}
