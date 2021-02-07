//
//  WidgetFactory.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/4.
//

import Foundation
import SwiftUI

struct WidgetFactory: View {
    var currentDate: Date
    var widgetGroupType: WidgetGroupType
    var sizeStyle: SizeStyle
    var body: some View {
        
        let config: WidgetPackge = StuffWidgetHelper.default.fetchCurrentConfig(groupId: widgetGroupType.rawValue)
        var widget: WidgetConfig = config.small
        if sizeStyle == .small {
            widget = config.small
        } else if sizeStyle == .middle {
            widget = config.middle
        } else {
            widget = config.large
        }
        if let layoutType = widget.layoutType {
            if layoutType == .layout0 {
                let view = WidgetViewLayout0.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout1 {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout2 {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout3 {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout4 {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout5 {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout6 {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout7 {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout8 {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            }
        } else {
            let view = WidgetViewLayout0.init(config: widget, currentDate: currentDate, style: sizeStyle)
            return AnyView(view)
        }
        
        let view = WidgetViewLayout0.init(config: widget, currentDate: currentDate, style: sizeStyle)
        return AnyView(view)
    }
}

struct WidgetFactoryPreview: View {
    var currentDate: Date
    let widget: WidgetConfig
    var sizeStyle: SizeStyle
    var body: some View {
        
        if let layoutType = widget.layoutType {
            if layoutType == .layout0 {
                let view = WidgetViewLayout0.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout1 {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout2 {
                let view = WidgetViewLayout2.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout3 {
                let view = WidgetViewLayout3.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout4 {
                let view = WidgetViewLayout4.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout5 {
                let view = WidgetViewLayout5.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout6 {
                let view = WidgetViewLayout6.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout7 {
                let view = WidgetViewLayout7.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else if layoutType == .layout8 {
                let view = WidgetViewLayout8.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            } else {
                let view = WidgetViewLayout1.init(config: widget, currentDate: currentDate, style: sizeStyle)
                return AnyView(view)
            }
        } else {
            let view = WidgetViewLayout0.init(config: widget, currentDate: currentDate, style: sizeStyle)
            return AnyView(view)
        }
        
        let view = WidgetViewLayout0.init(config: widget, currentDate: currentDate, style: sizeStyle)
        return AnyView(view)
        
    }
}
