//
//  PlistDataProvider.swift
//  ShortNews
//
//  Created by Roshan yadav on 18/09/24.
//

import Foundation

protocol keyDataProvider {
    func getConfigStringValue(for key: String) -> String?
}

class PlistDataProvider {
    private func getPlistData(from bundle: Bundle, name: String) -> [String: AnyObject]? {
        // Get the path to the plist file
        if let path = bundle.path(forResource: name, ofType: "plist") {
            // Create a dictionary from the plist file
            return NSDictionary(contentsOfFile: path) as? [String: AnyObject]
        }
        return nil
    }
    
    func getConfigStringValue(for key: String) -> String? {
        guard let plist = getPlistData(from: .main, name: "Configs") else {return nil}
        // Get the Key value from the dictionary
        return plist[key] as? String
    }
    
}

extension PlistDataProvider: keyDataProvider {}
