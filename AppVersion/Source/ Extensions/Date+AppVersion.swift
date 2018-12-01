//
//  Date+AppVersion.swift
//  AppVersion
//

import Foundation

extension Date {
    func daysFromToday() -> UInt {
        return UInt(abs(Calendar.current.dateComponents([.day], from: self, to: Date()).day!))
    }
}
