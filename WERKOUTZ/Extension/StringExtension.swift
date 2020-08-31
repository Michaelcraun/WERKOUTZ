//
//  StringExtension.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/14/20.
//

import Foundation

extension String {
    var userRepresentableTime: String {
        var value = self
        
        return value
        
        let time = TimeInterval(self.replacingOccurrences(of: ":", with: "")) ?? 0
        return time.userRepresentableTime
    }
}
