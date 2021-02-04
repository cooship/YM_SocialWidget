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
        let view = WidgetViewLayout0.init(config: widget, currentDate: currentDate, style: sizeStyle)
        return view
        
    }
}

struct WidgetFactoryPreview: View {
    var currentDate: Date
    let widget: WidgetConfig
    var sizeStyle: SizeStyle
    var body: some View {
        
        let view = WidgetViewLayout0.init(config: widget, currentDate: currentDate, style: sizeStyle)
        return AnyView(view)
    }
}
