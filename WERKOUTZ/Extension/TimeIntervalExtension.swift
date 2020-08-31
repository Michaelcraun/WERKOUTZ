//
//  TimeIntervalExtension.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/13/20.
//

import Foundation

extension TimeInterval {
    var userRepresentableTime: String {
        print("TimeInterval - \(#function)", hours, minutes, seconds)
        return String(format: "%02u:%02u:%02u", hours, minutes, seconds)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.allowsFractionalUnits = true
        formatter.unitsStyle = .positional
        formatter.maximumUnitCount = 4
        return formatter.string(from: self)!
    }
    
    var hours: TimeInterval {
        return self / 3600
    }
    
    var minutes: TimeInterval {
        return (self / 60).truncatingRemainder(dividingBy: 60)
    }
    
    var seconds: TimeInterval {
        return self.truncatingRemainder(dividingBy: 60)
    }
    
//    func seconds() -> TimeInterval {
//        return self.truncatingRemainder(dividingBy: 60).rounded(.down)
//    }
    
//    func minutes() -> TimeInterval {
//        return (self / 60).rounded(.down)
//    }
    
//    func hours() -> TimeInterval {
//        return (minutes / 60).rounded(.down)
//    }
    
    func days() -> TimeInterval {
        return (hours / 24).rounded(.down)
    }
    
    func months() -> TimeInterval {
        return (days() / 30).rounded(.down)
    }
    
    func years() -> TimeInterval {
        return (months() / 12).rounded(.down)
    }
    
    
}
