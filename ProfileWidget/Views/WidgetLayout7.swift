//
//  WidgetLayout7.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/4.
//

import Foundation
import SwiftUI
import WidgetKit
import DynamicColor

struct WidgetViewLayout7: View {
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
            GeometryReader { geometry in
                VStack {
                    Spacer()
                        .frame(width: 18, alignment: .center)
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            if let stickerName = configInfo.stickerImgName {
                                Image(uiImage:  UIImage(named: stickerName) ?? UIImage())
                                    .resizable()
                                    .frame(width: 23, height: 23, alignment: .center)
                                    
                            }
                        }
                        Spacer()
                        if let profileData = configInfo.userProfileImgData {
                            ZStack {
                                Circle()
                                    .foregroundColor(.black)
                                    .frame(width: 66, height: 66, alignment: .center)
                                Image(uiImage: UIImage(data: profileData) ?? UIImage(named: "ins_muban_6") ?? UIImage())
                                    .resizable()
                                    .frame(width: 56, height: 56, alignment: .center)
                                    .mask(Circle().frame(width: 56, height: 56, alignment: .center))
                            }
                        }
                        Spacer()
                            .frame(width: 18, alignment: .center)
                    }.frame(height: geometry.size.height/2, alignment: .center)
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(configInfo.fanCount ?? "1")")
                            .font(Font(UIFont(name: configInfo.textFont ?? "Avenir", size: 24)!))
                            .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                            .minimumScaleFactor(0.3)
                        Spacer()
                            .frame(width: 10)
                        Text("Foll\("owers")")
                            .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                            .font(Font(UIFont(name: "Helvetica-Light", size: 14)!))
                            .minimumScaleFactor(0.3)
                        Spacer()
                    }.frame(height: 40, alignment: .center)
                    Spacer()
                        .frame(height: 30, alignment: .center)
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
                    contentView
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            }
        }
        
        var contentView: some View {
            GeometryReader { geometry in
                HStack {
                   
                    VStack {
                        Spacer()
                        
                        
                        HStack {
                            Spacer()
                                .frame(width: 24)
                            
                            if let profileData = configInfo.userProfileImgData{
                                HStack {
                                    
                                    Image(uiImage: UIImage(data: profileData) ?? UIImage())
                                        .resizable()
                                        .frame(width: 24, height: 24, alignment: .center)
                                    Spacer()
                                }
                               
                                
                            }
                            Text("@\(configInfo.userName ?? "1")")
                                .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                                .font(Font(UIFont(name: "Helvetica-Bold", size: 14)!))
                                .minimumScaleFactor(0.3)
                                
                            Spacer()
                        }.frame(width: geometry.size.width / 2, alignment: .leading)
                        
                        Spacer()
                        
                        Spacer()
                            
                        HStack {
                            Spacer()
                                .frame(width: 24)
                            Text("\(configInfo.fanCount ?? "1")")
                                .font(Font(UIFont(name: configInfo.textFont ?? "Avenir", size: 32)!))
                                .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                                .frame(height: 30, alignment: .leading)
                                .minimumScaleFactor(0.3)
//                            Spacer()
//                                .frame(height: 1)
                            Text("Foll\("owers")")
                                .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                                .font(Font(UIFont(name: "Helvetica-Light", size: 14)!))
                                .frame(width: 60,height: 24, alignment: .bottom)
                                .minimumScaleFactor(0.3)
                        }
                        .frame(width: geometry.size.width / 2, alignment: .leading)
                        Spacer()
                        
                    }.frame(width: geometry.size.width / 2, height: geometry.size.height, alignment: .center)
                    Spacer()
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
                }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
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
                    HStack {
                        
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 40)
                                if let stickerName = configInfo.stickerImgName {
                                    Image(uiImage:  UIImage(named: stickerName) ?? UIImage())
                                        .resizable()
                                        .frame(width: 24, height: 24, alignment: .center)
                                        
                                }
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                    .frame(width: 40)
                                Text("@\(configInfo.userName ?? "1")")
                                    .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                                    .font(Font(UIFont(name: "Helvetica-Bold", size: 14)!))
                                    .minimumScaleFactor(0.3)
                                Spacer()
                            }
                            
                        }.frame(width: geometry.size.width / 2, alignment: .leading)
                        Spacer()
                        if let profileData = configInfo.userProfileImgData {
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60, alignment: .center)
                                Image(uiImage: UIImage(data: profileData) ?? UIImage(named: "ins_muban_6") ?? UIImage())
                                    .resizable()
                                    .frame(width: 56, height: 56, alignment: .center)
                                    .mask(Circle().frame(width: 56, height: 56, alignment: .center))
                                    
                            }.frame(width: geometry.size.width / 2)
                            
                        }
                        Spacer()
                    }.frame(width: geometry.size.width, height: geometry.size.height / 2)
                    Spacer()
                    HStack {
                        Spacer()
                            .frame(width: 40)
                        VStack {
                            Spacer()
                            Text("\(configInfo.fanCount ?? "1")")
                                .font(Font(UIFont(name: configInfo.textFont ?? "Avenir", size: 24)!))
                                .minimumScaleFactor(0.3)
                                .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                        }.frame(height: 50, alignment: .bottom)
                        .offset(x: 0, y: 5)
                        VStack {
                            Spacer()
                            Text("Foll\("owers")")
                                .foregroundColor(Color(DynamicColor(hexString: configInfo.textColor?.color ?? "#FFFFFF")))
                                .font(Font(UIFont(name: "Helvetica-Light", size: 14)!))
                                .minimumScaleFactor(0.3)
                            
                        }.frame(height: 50, alignment: .bottom)
                        Spacer()
                    }.frame(width: geometry.size.width, height: 50, alignment: .bottom)
                     
                    
                    Spacer()
                }
            }
        }
    }
}
