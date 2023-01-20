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
        for ele in self {
            if (ele as! String).count > 0 {
                let tempStr = "\u{25CF} " + "\(ele) \n\n"
                let bulletStr = "\u{25CF}"
                let range = (tempStr as NSString).range(of: bulletStr)
                let attribute = NSMutableAttributedString.init(string: tempStr)
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "Orange")! , range: range)
                str.append(attribute)
            }
        }
        return str
    }
}
