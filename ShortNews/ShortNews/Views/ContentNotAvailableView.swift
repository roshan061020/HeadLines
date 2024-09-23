//
//  ContentNotAvailableView.swift
//  ShortNews
//
//  Created by Roshan yadav on 23/09/24.
//

import SwiftUI

struct ContentNotAvailableView: View {
    var systemImageName: String
    var message: String
    var body: some View {
        VStack {
            Image(systemName: systemImageName)
                .symbolRenderingMode(.multicolor)
            
                .resizable()
                .frame(width: 75, height: 75)
            
            Text(message)
                .font(.title)
        }
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
