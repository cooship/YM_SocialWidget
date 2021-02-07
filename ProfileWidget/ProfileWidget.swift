//
//  ProfileWidget.swift
//  ProfileWidget
//
//  Created by JOJO on 2021/2/4.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    var widgetGroupType: WidgetGroupType = .profile
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetGroupType: .profile)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), widgetGroupType: .profile)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, widgetGroupType: .profile)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetGroupType: WidgetGroupType
}

struct ProfileWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        var sizeStyle: SizeStyle = .small
        if widgetFamily == .systemMedium {
            sizeStyle = .middle
        } else if widgetFamily == .systemLarge {
            sizeStyle = .large
        }
        // Widget 更新视图 是从 WidgetFactory View 里面更新
         
        
        return AnyView(WidgetFactory.init(currentDate: entry.date, widgetGroupType: entry.widgetGroupType, sizeStyle: sizeStyle))
    }
}

@main
struct ProfileWidget: Widget {
    let kind: String = "ProfileWidget"
    var widgetType: WidgetGroupType = .profile
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider.init(widgetGroupType: widgetType)) { entry in
            ProfileWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ProfileWidget_Previews: PreviewProvider {
    static var previews: some View {
        ProfileWidgetEntryView(entry: SimpleEntry(date: Date(), widgetGroupType: .profile))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
