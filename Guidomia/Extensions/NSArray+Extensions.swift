//
//  NSArray+Extensions.swift
//  Guidomia
//
//  Created by Kamal Trapasiya on 2023-01-19.
//

import UIKit

extension NSArray {
    func convertArrToString() -> NSMutableAttributedString {
        let str = NSMutableAttributedString()
        let arr = self.filter { ($0 as! String).trimmingCharacters(in: .whitespacesAndNewlines).count != 0 }
        for i in 0..<arr.count {
            let bulletStr = "\u{2981}"
            let tempStr = i == arr.count - 1 ? bulletStr + " " + "\(arr[i])" : bulletStr + " " + "\(arr[i]) \n\n"
            let range = (tempStr as NSString).range(of: bulletStr)
            let attribute = NSMutableAttributedString.init(string: tempStr)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "Orange")! , range: range)
            str.append(attribute)
        }
        return str
    }
}
