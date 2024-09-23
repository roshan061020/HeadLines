//
//  CategoryType.swift
//  ShortNews
//
//  Created by Roshan yadav on 23/09/24.
//

import Foundation

enum CategoryType: String, CaseIterable {
    case general = "General"
    case business = "Business"
    case technology = "Technology"
    case health = "Health"
    case sports = "Sports"
    case entertainment = "Entertainment"
    case science = "Science"
    
    var capitalised: String {
        self.rawValue.capitalized
    }
}
