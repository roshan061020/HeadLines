//
//  RoundedButton.swift
//  Headlines
//
//  Created by Roshan yadav on 23/09/24.
//

import SwiftUI

struct RoundedButton: View {
    var title: String
    var action: ()->()
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding([.horizontal, .bottom])
            
        }
    }
}


#Preview {
    RoundedButton(title: "Hello", action: {})
}
