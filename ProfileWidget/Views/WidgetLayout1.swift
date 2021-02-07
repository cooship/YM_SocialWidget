//
//  WidgetLayout1.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/4.
//

import Foundation
import SwiftUI
import WidgetKit
import DynamicColor

struct WidgetViewLayout1: View {
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

                ZStack {
                    if let profileData = configInfo.userProfileImgData {
                        Image(uiImage: UIImage(data: profileData) ?? UIImage(named: "ins_muban_6") ?? UIImage())
                            .resizable()
                            .frame(width: 56, height: 56, alignment: .center)
                            .mask(Circle().frame(width: 56, height: 56, alignment: .center))
                    }
                    if let stickerName = configInfo.stickerImgName {
                        Image(uiImage:  UIImage(named: stickerName) ?? UIImage())
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .center)
                            .offset(x: 0, y: 25)
                    }
                }
                
                Spacer()
                    .frame(height: 22)
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
                Spacer()

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
                    HStack {
                        Spacer()
                            .frame(height: 36)
                        VStack {
                            
                            Spacer()
                            
                            Text("\(configInfo.fanCount ?? "1")")
                                .font(Font(UIFont(name: configInfo.textFont ?? "Avenir", size: 32)!))
                                .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                                .frame(width: geometry.size.width/2 - 40, alignment: .leading)
                            Spacer()
                                .frame(height: 15)
                            Text("Foll\("owers")")
                                .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                                .font(Font(UIFont(name: "Helvetica-Light", size: 14)!))
                                .frame(width: geometry.size.width/2 - 40, alignment: .leading)
                            Spacer()
                                .frame(height: 15)
                            Text("@\(configInfo.userName ?? "1")")
                                .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                                .font(Font(UIFont(name: "Helvetica-Bold", size: 14)!))
                                .frame(width: geometry.size.width/2 - 40, alignment: .leading)
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width/2, height: geometry.size.height)
                    ZStack {
                        if let profileData = configInfo.userProfileImgData {
                            Image(uiImage: UIImage(data: profileData) ?? UIImage(named: "ins_muban_6") ?? UIImage())
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .mask(Circle().frame(width: 100, height: 100, alignment: .center))
                        }
                        if let stickerName = configInfo.stickerImgName {
                            Image(uiImage: UIImage(named: stickerName) ?? UIImage())
                                .resizable()
                                .frame(width: 24, height: 24, alignment: .center)
                                .offset(x: -40, y: 40)
                        }
                    }.frame(width: geometry.size.width/2, height: geometry.size.height)
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
                    ZStack {
                        if let profileData = configInfo.userProfileImgData {
                            Image(uiImage: UIImage(data: profileData) ?? UIImage(named: "ins_muban_6") ?? UIImage())
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .mask(Circle().frame(width: 100, height: 100, alignment: .center))
                        }
                        if let stickerName = configInfo.stickerImgName {
                            Image(uiImage: UIImage(named: stickerName) ?? UIImage())
                                .resizable()
                                .frame(width: 24, height: 24, alignment: .center)
                                .offset(x: -0, y: 50)
                        }
                    }
                    
                    Spacer()
                    
                    Text("@\(configInfo.userName ?? "1")")
                        .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                        .font(Font(UIFont(name: "Helvetica-Bold", size: 18)!))
                    Spacer()

                    Text("\(configInfo.fanCount ?? "1")")
                        .font(Font(UIFont(name: configInfo.textFont ?? "Avenir", size: 40)!))
                        .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))

                    Spacer()
                        .frame(height: 10)
                    Text("Foll\("owers")")
                        .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                        .font(Font(UIFont(name: "Helvetica-Light", size: 14)!))

                    
                    Spacer()

                }.frame(width: geometry.size.width, alignment: .center)
            }
        }
    }
}
