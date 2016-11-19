//
//  Time.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/18/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import Foundation

class Time
{
    var date:Date!
    var dateFormatter:DateFormatter!
    init()
    {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
    
    func timeAgoInWords(dateString:String) -> String
    {
        let minutes_in_seconds:Double = 60.0
        let hours_in_seconds:Double = minutes_in_seconds * 60.0
        let day_in_seconds:Double = hours_in_seconds
        let month_in_seconds:Double = day_in_seconds * 30.0
        let year_in_seconds:Double = day_in_seconds * 365.0
        var returnString = ""
        
        self.date = dateFormatter.date(from: dateString)
        
        let seconds = abs(date.timeIntervalSinceNow)
        
        if seconds < 59.0
        {
            returnString = "\(seconds) seconds ago"
        }
        else if seconds < minutes_in_seconds + (minutes_in_seconds - 1)
        {
            returnString = "1 minute ago"
        }
        else if seconds < hours_in_seconds - minutes_in_seconds
        {
            let minutes = Int(round(seconds / minutes_in_seconds))
            returnString = "\(minutes) minutes ago"
        }
        else if seconds < hours_in_seconds + (hours_in_seconds - minutes_in_seconds)
        {
            returnString = "1 hour ago"
        }
        else if seconds < day_in_seconds - hours_in_seconds
        {
            let hours = Int(round(seconds / hours_in_seconds))
            returnString = "\(hours) hours ago"
        }
        else if seconds < day_in_seconds + (day_in_seconds - hours_in_seconds)
        {
            returnString = "1 day ago"
        }
        else if seconds < month_in_seconds - day_in_seconds
        {
            let days = Int(round(seconds / day_in_seconds))
            returnString = "\(days) days ago"
        }
        else if seconds < month_in_seconds + (month_in_seconds - day_in_seconds)
        {
            returnString = "1 month ago"
        }
        else if seconds < year_in_seconds - month_in_seconds
        {
            let months = Int(round(seconds / month_in_seconds))
            returnString = "\(months) months ago"
        }
        else if seconds < year_in_seconds * 99
        {
            let months = Int(round(seconds / year_in_seconds))
            returnString = "\(months) months ago"
        }
        
        return returnString
    }
}
