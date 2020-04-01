//
//  ComplicationController.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/15/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        // Call the handler with the current timeline entry
        
        switch complication.family {
            
        case .graphicCircular:
            
            if let startDate = TimerHolder.sharedInstance.startDate {
            
                let displayDate = TimerHolder.sharedInstance.isRunning ? startDate : TimerHolder.sharedInstance.stopDate ?? Date()
        
                let template = CLKComplicationTemplateGraphicCircularOpenGaugeRangeText()
                
                template.centerTextProvider = CLKSimpleTextProvider(text: "🔥")// CLKRelativeDateTextProvider(date: displayDate, style: .timer, units: .minute)
                /*
                let thermometerBlack = UIImage(systemName: "thermometer")!
                let thermometer = thermometerBlack.withTintColor(.white, renderingMode: .alwaysOriginal)
                template.imageProvider = CLKFullColorImageProvider(fullColorImage: thermometer)
                */
                template.leadingTextProvider = CLKSimpleTextProvider(text: "0")
                template.trailingTextProvider = CLKSimpleTextProvider(text: "30")
                template.gaugeProvider = CLKTimeIntervalGaugeProvider(
                    style: .ring,
                    gaugeColors: [UIColor.brown, UIColor.red, UIColor.orange, UIColor.yellow, UIColor.purple],
                    gaugeColorLocations: [NSNumber(value: 0.0/30), NSNumber(value: 5.0/30), NSNumber(value: 10.0/30), NSNumber(value: 15.0/30), NSNumber(value: 30.0/30)],
                    start: displayDate,
                    end: displayDate.addingTimeInterval(30 * 60))
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(entry)
            }
            else {
                let template = CLKComplicationTemplateGraphicCircularStackText()
                template.line1TextProvider = CLKSimpleTextProvider(text: "CA")
                template.line2TextProvider = CLKSimpleTextProvider(text: "FE")
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(entry)
            }
            
        case .graphicRectangular:
            
            if let startDate = TimerHolder.sharedInstance.startDate {
                
                let displayDate = TimerHolder.sharedInstance.isRunning ? startDate : TimerHolder.sharedInstance.stopDate ?? Date()
                let displayStyle : CLKRelativeDateStyle = TimerHolder.sharedInstance.isRunning ? .timer : .natural
                
                let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "Coffee Calc & Timer")
                template.body1TextProvider = CLKRelativeDateTextProvider(date: displayDate, style: displayStyle, units: [.minute, .second])
                template.body2TextProvider = CLKSimpleTextProvider(text: TimerHolder.sharedInstance.isRunning ? ">" : "x")
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(entry)
            }
            else {
                let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "Coffee Calc & Timer")
                template.body1TextProvider = CLKSimpleTextProvider(text: "COFFEE")
                template.body2TextProvider = CLKSimpleTextProvider(text: "CAFE")
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(entry)
            }
            
        default:
            handler(nil)
        }
        
        
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        
        switch complication.family {
            
        case .graphicCircular:
            
            if let startDate = TimerHolder.sharedInstance.startDate {
                
                let displayDate = TimerHolder.sharedInstance.isRunning ? startDate : TimerHolder.sharedInstance.stopDate ?? Date()
                
                let template = CLKComplicationTemplateGraphicCircularOpenGaugeRangeText()
                
                template.centerTextProvider = CLKSimpleTextProvider(text: "👌")// CLKRelativeDateTextProvider(date: displayDate, style: .timer, units: .minute)
                /*
                 let thermometerBlack = UIImage(systemName: "thermometer")!
                 let thermometer = thermometerBlack.withTintColor(.white, renderingMode: .alwaysOriginal)
                 template.imageProvider = CLKFullColorImageProvider(fullColorImage: thermometer)
                 */
                template.leadingTextProvider = CLKSimpleTextProvider(text: "0")
                template.trailingTextProvider = CLKSimpleTextProvider(text: "30")
                template.gaugeProvider = CLKTimeIntervalGaugeProvider(
                    style: .ring,
                    gaugeColors: [UIColor.brown, UIColor.red, UIColor.orange, UIColor.yellow, UIColor.purple],
                    gaugeColorLocations: [NSNumber(value: 0.0/30), NSNumber(value: 5.0/30), NSNumber(value: 10.0/30), NSNumber(value: 15.0/30), NSNumber(value: 30.0/30)],
                    start: displayDate,
                    end: displayDate.addingTimeInterval(30 * 60))
                var entries = [CLKComplicationTimelineEntry(date: displayDate.addingTimeInterval(10 * 60), complicationTemplate: template)]
                
                let template2 = CLKComplicationTemplateGraphicCircularStackText()
                template2.line1TextProvider = CLKSimpleTextProvider(text: "CA")
                template2.line2TextProvider = CLKSimpleTextProvider(text: "FE")
                entries.append(CLKComplicationTimelineEntry(date: displayDate.addingTimeInterval(30 * 60), complicationTemplate: template2))
                
                handler(entries)
            }
            else {
                handler(nil)
            }
        
        case .graphicRectangular:
            
            if let startDate = TimerHolder.sharedInstance.startDate {
            
                let displayDate = TimerHolder.sharedInstance.isRunning ? startDate : TimerHolder.sharedInstance.stopDate ?? Date()
                    
                let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "Coffee Calc & Timer")
                template.body1TextProvider = CLKSimpleTextProvider(text: "COFFEE")
                template.body2TextProvider = CLKSimpleTextProvider(text: "CAFE")
                let entries = [CLKComplicationTimelineEntry(date: displayDate.addingTimeInterval(30 * 60), complicationTemplate: template)]
                handler(entries)
            }
            else {
                handler(nil)
            }
            
        default:
            handler(nil)
        }
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        switch complication.family {
        
        case .graphicCircular:
        
            let template = CLKComplicationTemplateGraphicCircularStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "CA")
            template.line2TextProvider = CLKSimpleTextProvider(text: "FE")
            handler(template)
            
        case .graphicRectangular:
            
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Coffee Calc & Timer")
            template.body1TextProvider = CLKSimpleTextProvider(text: "COFFEE")
            template.body2TextProvider = CLKSimpleTextProvider(text: "CAFE")
            handler(template)
        
        default:
            handler(nil)
        }
    }
    
}
