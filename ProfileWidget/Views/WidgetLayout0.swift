//
//  WidgetLayout0.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/4.
//

import Foundation
import SwiftUI
import WidgetKit

struct BgColorImgView: View {
    var bgColor: ThemeColor?
    var sizeType: SizeStyle = .small
    
    var body: some View {
        
        if let imgName = bgColor?.bgImgName {
            
            if let img = StuffWidgetHelper.default.bgImg(name: imgName, sizeStyle: sizeType) {
                
                Image(uiImage: img).resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .clipped()
                    
            }
            
        } else if let gradientColor = bgColor?.gradientColor {
            let colors = progressGradientColors(gradientColor: gradientColor)
            LinearGradient(gradient: Gradient(colors: colors), startPoint: UnitPoint(x: gradientColor.startPoint.x, y: gradientColor.startPoint.y), endPoint: UnitPoint(x: gradientColor.endPoint.x, y: gradientColor.endPoint.y)).edgesIgnoringSafeArea(.all)
                
        } else if let color = bgColor?.normalColor {
            Color(UIColor(hexaRGB: color.color, alpha: color.alpha) ?? .clear)
        }
    }
}

struct WidgetViewLayout0: View {
    var config: WidgetConfig
    var currentDate: Date
    var style: SizeStyle
    
    var body: some View {
        switch style {
        case .small:
            return AnyView(CanvasView_Small(currentDate: currentDate, configInfo: config))
        case .middle:
            return AnyView(CanvasView_Middle(currentDate: currentDate, configInfo: config))
        case .large:
            return AnyView(CanvasView_Small(currentDate: currentDate, configInfo: config))
        }
    }
    
    
    
    struct CanvasView_Small: View {
        var currentDate: Date = Date()
        var configInfo: WidgetConfig
 
        
        var body: some View {
            
            GeometryReader { geometry in
                
                let _ = UIColor.init(hexaRGB: configInfo.textColor?.color ?? "#000000", alpha: configInfo.textColor?.alpha ?? 1) ?? UIColor.white
                    
                ZStack {
                    BgColorImgView.init(bgColor: configInfo.bgColor, sizeType: .small)
                    
                }
            }
        }
    }
    
    struct CanvasView_Middle: View {
        var currentDate: Date = Date()
        var configInfo: WidgetConfig
         
        var body: some View {
            
            GeometryReader { geometry in
                
                let _ = UIColor.init(hexaRGB: configInfo.textColor?.color ?? "#000000", alpha: configInfo.textColor?.alpha ?? 1) ?? UIColor.white
                    
                ZStack {
                    BgColorImgView.init(bgColor: configInfo.bgColor, sizeType: .middle)
                    
                }
            }
        }
    }
    
    struct CanvasView_Large: View {
        var currentDate: Date = Date()
        var configInfo: WidgetConfig
         
        
        var body: some View {
            
            GeometryReader { geometry in
                
                let _ = UIColor.init(hexaRGB: configInfo.textColor?.color ?? "#000000", alpha: configInfo.textColor?.alpha ?? 1) ?? UIColor.white
                    
                ZStack {
                    BgColorImgView.init(bgColor: configInfo.bgColor, sizeType: .small)
                    
                }
            }
        }
    }
    
    
}
