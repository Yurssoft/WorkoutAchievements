//
//  Extensions.swift
//  
//
//  Created by Yurii B on 10/10/23.
//

import Foundation

extension Date {
    func convert() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func shortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: self)
        return date
    }
}

extension Double {
    func convert(dimension: Dimension) -> String {
        let measurement = Measurement(value: self, unit: dimension)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.numberStyle = .decimal
        let string = formatter.string(from: measurement)
        return string
    }
}
