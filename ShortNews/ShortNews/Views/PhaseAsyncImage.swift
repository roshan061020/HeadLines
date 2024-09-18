//
//  PhaseAsyncImage.swift
//  ShortNews
//
//  Created by Roshan yadav on 18/09/24.
//

import Foundation
import SwiftUI

struct PhaseAsyncImage: View {
    let imageUrl: URL?
    var imageWidth = UIScreen.main.bounds.width - 40
    
    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable().aspectRatio(contentMode: .fill)
            case .failure(_):
                Image(systemName: "xmark.rectangle")
                    .resizable().aspectRatio(contentMode: .fit)
            @unknown default:
                Image(systemName: "xmark.rectangle")
                    .resizable().aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: imageWidth, height: 200)
    }
}

#Preview {
    PhaseAsyncImage(imageUrl: URL(string: "https://picsum.photos/400"))
}
