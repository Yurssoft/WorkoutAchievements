//
//  Extensions.swift
//  
//
//  Created by Yurii B on 10/10/23.
//

import Foundation

extension Date {
    func mediumDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func shortDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: self)
        return date
    }
}

extension Double {
    func toString(dimension: Dimension, digits: Int = 0) -> String {
        let measurement = Measurement(value: self, unit: dimension)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = digits
        formatter.numberFormatter.numberStyle = .decimal
        let string = formatter.string(from: measurement)
        return string
    }
}
