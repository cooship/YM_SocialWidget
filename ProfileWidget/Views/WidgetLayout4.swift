//
//  WidgetLayout4.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/4.
//

import Foundation
import SwiftUI
import WidgetKit
import DynamicColor

struct WidgetViewLayout4: View {
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
            return AnyView(CanvasView_Large(currentDate: currentDate, configInfo: config))
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
                    contentView
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            }
        }
        
        
        var contentView: some View {
            
            VStack {
                Spacer()
                    .frame(height: 10)
                if let profileData = configInfo.userProfileImgData {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60, alignment: .center)
                        Image(uiImage: UIImage(data: profileData) ?? UIImage(named: "ins_muban_6") ?? UIImage())
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .mask(Circle().frame(width: 50, height: 50, alignment: .center))
                    }
                }
                Text("@\(configInfo.userName ?? "1")")
                    .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                    .font(Font(UIFont(name: "Helvetica-Bold", size: 12)!))
                    .minimumScaleFactor(0.3)
                Text("\(configInfo.fanCount ?? "1")")
                    .font(Font(UIFont(name: configInfo.textFont ?? "Avenir", size: 24)!))
                    .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                    .minimumScaleFactor(0.3)
                Spacer()
                    .frame(height: 4)
                Text("Foll\("owers")")
                    .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                    .font(Font(UIFont(name: "Helvetica-Light", size: 14)!))
                    .minimumScaleFactor(0.3)
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
                    contentView
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            }
        }
        
        var contentView: some View {
            GeometryReader { geometry in
                
                
                HStack {
                    Spacer()
                        .frame(width: 20)
                    if let profileData = configInfo.userProfileImgData {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 110, height: 110, alignment: .center)
                            Image(uiImage: UIImage(data: profileData) ?? UIImage(named: "ins_muban_6") ?? UIImage())
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .mask(Circle().frame(width: 100, height: 100, alignment: .center))
                        }
                    }
                    Spacer()
                    VStack {
                        
                        Spacer()
                        Text("@\(configInfo.userName ?? "1")")
                            .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                            .font(Font(UIFont(name: "Helvetica-Bold", size: 14)!))
                            .frame(width: geometry.size.width/2 - 40, alignment: .center)
                        Spacer()
                            .frame(height: 15)
                        Text("\(configInfo.fanCount ?? "1")")
                            .font(Font(UIFont(name: configInfo.textFont ?? "Avenir", size: 36)!))
                            .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                            .frame(width: geometry.size.width/2 - 40, alignment: .center)
                        Spacer()
                            .frame(height: 15)
                        Text("Foll\("owers")")
                            .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                            .font(Font(UIFont(name: "Helvetica-Light", size: 14)!))
                            .frame(width: geometry.size.width/2 - 40, alignment: .center)
                        
                        Spacer()
                    }
                    Spacer()
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
                    contentView
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            }
        }
        
        var contentView: some View {
            GeometryReader { geometry in
                
                VStack {
                    Spacer()
                        .frame( height: 28)
                    if let profileData = configInfo.userProfileImgData {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 110, height: 110, alignment: .center)
                            Image(uiImage: UIImage(data: profileData) ?? UIImage(named: "ins_muban_6") ?? UIImage())
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .mask(Circle().frame(width: 100, height: 100, alignment: .center))
                        }
                    }
                    Text("@\(configInfo.userName ?? "1")")
                        .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                        .font(Font(UIFont(name: "Helvetica-Bold", size: 18)!))
                    Spacer()
                        
                    Text("\(configInfo.fanCount ?? "1")")
                        .font(Font(UIFont(name: configInfo.textFont ?? "Avenir", size: 40)!))
                        .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                    Spacer()
                        .frame( height: 4)
                    Text("Foll\("owers")")
                        .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                        .font(Font(UIFont(name: "Helvetica-Light", size: 14)!))
                    Spacer()
                }.frame(width: geometry.size.width, alignment: .center)
            }
        }
    }
}
