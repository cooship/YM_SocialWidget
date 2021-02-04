//
//  Stuff.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/4.
//

import Foundation
import SwiftUI
import WidgetKit
import UIKit

let groupKey: String = "group.com.socialwidget"

enum WidgetGroupType: String {
    case profile
}

struct WidgetPackge: Codable {
    var groupId: String = WidgetGroupType.profile.rawValue
    var small: WidgetConfig
    var middle: WidgetConfig
    var large: WidgetConfig
    enum CodingKeys: String, CodingKey {
        case small, middle, large, groupId
    }
}


struct WidgetConfig: Codable {
    var widgetIdName: String?
    
    var bgColor: ThemeColor?
    var layoutType: LayoutType?
    var sizeType: SizeStyle?
    var userProfileImgData: Data?
    var userName: String?
    var fullName: String?
    var fanCount: String?
    var textFont: String?
    var textColor: ThemeColor.p_Color?
    var stickerImgData: Data?
   
   
}


enum SizeStyle: String, Codable {
    case small
    case middle
    case large
    
    enum CodingKeys: String, CodingKey {
        case small, middle, large
    }
}

 
enum LayoutType: Int, Codable {
    case layout0 = 0
    case layout1 = 1
    case layout2 = 2
    case layout3 = 3
    case layout4 = 4
    case layout5 = 5
    case layout6 = 6
    case layout7 = 7
    case layout8 = 8
    
}




struct ThemeColor: Codable {
    var bgImgName: String?
    /// 普通颜色
    var normalColor: p_Color?
    /// 渐变色
    var gradientColor: GradientColor?
    
    enum CodingKeys: String, CodingKey {
        case bgImgName
        case normalColor
        case gradientColor
    }
    
    struct GradientColor: Codable {
        /// 普通颜色集合，最少两个元素
        var colors: [p_Color]
        /// start point
        var startPoint: Point
        /// end point
        var endPoint: Point
        
        enum CodingKeys: String, CodingKey {
            case colors
            case startPoint
            case endPoint
        }
        
        struct Point: Codable {
            var x: CGFloat
            var y: CGFloat
            enum CodingKeys: String, CodingKey {
                case x
                case y
            }
        }
    }
    
    struct p_Color: Codable {
        /// 颜色十六进制，如#FFFFFF
        var color: String
        /// 透明度，0-1
        var alpha: CGFloat
        
        enum CodingKeys: String, CodingKey {
            case color
            case alpha
        }
    }
}


extension UIImage {
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    func imageAtRect(rect: CGRect) -> UIImage{
        var rect = rect
        rect.origin.x *= self.scale
        rect.origin.y *= self.scale
        rect.size.width *= self.scale
        rect.size.height *= self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    func cropImage2(rect: CGRect, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
        self.draw(at: CGPoint(x: rect.origin.x / scale, y: rect.origin.y / scale))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage ?? self
    }
    
}

extension UIColor {
    
    convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: alpha)
    }

    convenience init?(hexaRGBA: String) {
        var chars = Array(hexaRGBA.hasPrefix("#") ? hexaRGBA.dropFirst() : hexaRGBA[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[6...7]), nil, 16)) / 255)
    }

    convenience init?(hexaARGB: String) {
        var chars = Array(hexaARGB.hasPrefix("#") ? hexaARGB.dropFirst() : hexaARGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
}



class StuffWidgetHelper {
    static let `default` = StuffWidgetHelper()
    
    func saveThemeConfigure(themeConfigs: [WidgetPackge]) {
        
        for themeConfig in themeConfigs {
            let groupId = themeConfig.groupId
            if let jsonData = try? JSONEncoder().encode(themeConfig) {
                // 编码成功，将 jsonData 转为字符输出查看
                if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                    print("jsonString:" + "\(jsonString)")
                    if let defaults = UserDefaults.init(suiteName: groupKey) {
                        defaults.set(jsonString, forKey: groupId)
                    } else {
                        debugPrint("no default")
                    }
                }
            }
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func saveThemeConfigure(themeConfig: WidgetPackge) {
        let groupId = themeConfig.groupId
        if let jsonData = try? JSONEncoder().encode(themeConfig) {
            // 编码成功，将 jsonData 转为字符输出查看
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                print("jsonString:" + "\(jsonString)")
                if let defaults = UserDefaults.init(suiteName: groupKey) {
                    defaults.set(jsonString, forKey: groupId)
                } else {
                    debugPrint("no default")
                }
            }
        }
        WidgetCenter.shared.reloadAllTimelines()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func fetchCurrentConfig(groupId: String) -> WidgetPackge {
        let defaults = UserDefaults.init(suiteName: groupKey)
        
        if let jsonString = defaults?.string(forKey: groupId) {
            if let jsonData = jsonString.data(using: String.Encoding.utf8) {
                if let configure = try? JSONDecoder().decode(WidgetPackge.self, from: jsonData){
                    return configure
                }
            }
        }
        
        if groupId == WidgetGroupType.profile.rawValue {
            var test1 = defaultCurrentWidgetConfig()
            test1.groupId = groupId
            saveThemeConfigure(themeConfig: test1)
            return test1
        } else {
            var test = defaultCurrentWidgetConfig()
            test.groupId = groupId
            saveThemeConfigure(themeConfig: test)
            return test
        }
        
    }
    //TODO: Widget Default Config
    func defaultCurrentWidgetConfig() -> WidgetPackge {
        // small
        // "buildinName:" "sandboxPath:"
        let smallbgColor = ThemeColor.init(bgImgName: "muban_img_l_default", normalColor: nil, gradientColor: nil)
        let smallConfig = WidgetConfig.init(widgetIdName: "small_profile", bgColor: smallbgColor, layoutType: .layout0, sizeType: .small)
        

        // middel
        let middelbgColor = ThemeColor.init(bgImgName: "muban_img_m_default", normalColor: nil, gradientColor: nil)
        let middelConfig = WidgetConfig.init(widgetIdName: "middel_profile", bgColor: middelbgColor, layoutType: .layout0, sizeType: .middle)
        
        // large
        let largebgColor = ThemeColor.init(bgImgName: "muban_img_l_default", normalColor: nil, gradientColor: nil)
        let largeConfig = WidgetConfig.init(widgetIdName: "large_profile", bgColor: largebgColor, layoutType: .layout0, sizeType: .large)
        
        let profilePackage = WidgetPackge.init(small: smallConfig, middle: middelConfig, large: largeConfig)
        
     
        return profilePackage
    }
    
    // smallBgName middleBgName
    func savePhotoToSandbox(image: UIImage, saveName: String, compress: Bool? = false) -> String {
        if let groupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupKey) {
            let filrUrl = groupUrl.appendingPathComponent("\(saveName).data")
            do {
                if compress ?? false {
                    let compImg = WWImageCompress.compressWithMaxCount(origin: image, maxCount: 100000)!
                    
                    try compImg.write(to: filrUrl)
                    return filrUrl.path
                } else {
                    let compImg = image.pngData()
                    
                    try compImg?.write(to: filrUrl)
                    return filrUrl.path
                    
                }
            } catch {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func widgetPreivew(viewHeight: CGFloat, size: SizeStyle, widgetConfig: WidgetConfig) -> UIView {
        
        // 如果 WidgetFactoryPreview Widget 里面的 UI 布局相关代码跟 宿主app Target Membership 关联 则 Widget 里面的 SwiftUI 无法实时预览
        
        let containerView = UIView()
        let widget =
            WidgetFactoryPreview.init(currentDate: Date(), widget: widgetConfig, sizeStyle: size)
        let widgetChild = UIHostingController(rootView: widget)
        widgetChild.view.layer.cornerRadius = 20
        containerView.addSubview(widgetChild.view)
        if size == .small {
            widgetChild.view.frame = CGRect(x: 0, y: 0, width: viewHeight, height: viewHeight)
        } else if size == .middle {
            widgetChild.view.frame = CGRect(x: 0, y: 0, width: (viewHeight) * 2, height: viewHeight)
        } else if size == .large {
            widgetChild.view.frame = CGRect(x: 0, y: 0, width: viewHeight, height: viewHeight)
        }
        containerView.frame = widgetChild.view.frame
        
        return containerView
        
    }
    
    func bgImg(name: String) -> UIImage? {
        if name.contains("buildinName:") {
            let imgName = (name).replacingOccurrences(of: "buildinName:", with: "")
            if let img = UIImage(named: imgName) {
                return img
            } else {
                return nil
            }
        } else if name.contains("sandboxPath:") {
            
            let imgSendboxUrl = URL(fileURLWithPath: (name).replacingOccurrences(of: "sandboxPath:", with: ""))
            if let imgData = try? Data.init(contentsOf: imgSendboxUrl),
                      let wallPaper = UIImage(data: imgData) {
                return wallPaper
            } else {
                return nil
            }
            
        } else if name.contains("imgData:") {
            
            let imgDataStr = (name).replacingOccurrences(of: "imgData:", with: "")
            if let data = Data.init(base64Encoded: imgDataStr), let img = UIImage.init(data: data) {
                return img
            } else {
                return nil
            }
        }
        else {
            if let img = UIImage(named: name) {
                return img
            } else {
                return nil
            }
        }
    }
    
    func bgImg(name: String, sizeStyle: SizeStyle) -> UIImage? {
        // "buildinName:" "sandboxPath:" "imgData:"
        let width: CGFloat = 300
        var targetSize = CGSize(width: width, height: width)
        if sizeStyle == .small {
            targetSize = CGSize(width: width, height: width)
        } else if sizeStyle == .middle {
            targetSize = CGSize(width: width * 2, height: width)
        } else {
            targetSize = CGSize(width: 600, height: 600)
        }
        
        if name.contains("buildinName:") {
            let imgName = (name).replacingOccurrences(of: "buildinName:", with: "")
            if let img = UIImage(named: imgName) {
                let fixImg = reSizeImage(originalImg: img, reSize: targetSize)
                return fixImg
            } else {
                return nil
            }
        } else if name.contains("sandboxPath:") {
            
            let imgSendboxUrl = URL(fileURLWithPath: (name).replacingOccurrences(of: "sandboxPath:", with: ""))
            if let imgData = try? Data.init(contentsOf: imgSendboxUrl),
                      let wallPaper = UIImage(data: imgData) {
                
                let fixImg = reSizeImage(originalImg: wallPaper, reSize: targetSize)
                return fixImg
            } else {
                return nil
            }
            
        } else if name.contains("imgData:") {
            
            let imgDataStr = (name).replacingOccurrences(of: "imgData:", with: "")
            if let data = Data.init(base64Encoded: imgDataStr), let img = UIImage.init(data: data) {
                let fixImg = reSizeImage(originalImg: img, reSize: targetSize)
                return fixImg
            } else {
                return nil
            }
        }
        
        else {
            if let img = UIImage(named: name) {
                let fixImg = reSizeImage(originalImg: img, reSize: targetSize)
                return fixImg
            } else {
                return nil
            }
        }
    }
 
    
    func reSizeImage(originalImg: UIImage, reSize:CGSize, isCenter: Bool = true)->UIImage {
        var fixImg: UIImage? = originalImg
        if originalImg.size.width / originalImg.size.height >= reSize.width / reSize.height {
            fixImg = originalImg.scaled(toHeight: reSize.height)
        } else {
            fixImg = originalImg.scaled(toWidth: reSize.width)
        }
        guard let fixImg_w = fixImg else { return originalImg; }
        if isCenter == true {
            
            let x: CGFloat = -(fixImg_w.size.width - reSize.width) / 2
            let y: CGFloat = -(fixImg_w.size.height - reSize.height) / 2
            let rect = CGRect(x: x, y: y, width: reSize.width, height: reSize.height)
            
            let reSizeImage = fixImg_w.cropImage2(rect: rect, scale: 1)
//            let reSizeImage = fixImg_w.cropped(to: rect)
            
            return reSizeImage;
        } else {
            let rect = CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height)
            let reSizeImage = fixImg_w.cropImage2(rect: rect, scale: 1)
            return reSizeImage;
        }
        
        
    }
}


func progressGradientColors(gradientColor: ThemeColor.GradientColor) -> [Color] {
    var colors: [Color] = []
    for color in gradientColor.colors {
        colors.append(Color(UIColor(hexaRGB: color.color, alpha: color.alpha) ?? .clear))
    }
    return colors
}



