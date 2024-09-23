//
//  ImageExtension.swift
//  ShortNews
//
//  Created by Roshan yadav on 18/09/24.
//

import Foundation

extension Date {
    func ToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd hh:mm"
        return dateFormatter.string(from: self)
    }
}
