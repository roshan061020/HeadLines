//
//  SelectableChipsView.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import SwiftUI

struct SelectableChipsView: View {
    var data: [String]
    @Binding var selectedChips: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(data, id: \.self) { chipTitle in
                    ChipView(name: chipTitle, isSelected: selectedChips == chipTitle )
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(10)
                        .padding(.horizontal, 10)
                        .background(.accent)
                        .clipShape(.capsule)
                        .onTapGesture {
                            withAnimation(.bouncy.delay(0.1)) {
                                selectedChips = chipTitle
                            }
                        }
                }
            }
        }
    }
}

struct ChipView: View {
    let name: String
    let isSelected: Bool
    
    var body: some View {
        HStack{
            if isSelected{
                Image(systemName: StringConstants.systemImageName.checkmark)
            }
            Text(name)
        }
    }
}
