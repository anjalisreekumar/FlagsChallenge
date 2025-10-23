//
//  Extension+Date.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import Foundation

extension Date {
    func formattedLocalString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
