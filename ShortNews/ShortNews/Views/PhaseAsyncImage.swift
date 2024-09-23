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
    var height: CGFloat = 200
    var contentMode = ContentMode.fill
    
    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable().aspectRatio(contentMode: contentMode)
            case .failure(_):
                failureImage
            @unknown default:
                failureImage
            }
        }
        .frame(width: imageWidth, height: height)
    }
    
    var failureImage: some View {
        Image(systemName: StringConstants.systemImageName.xRectangle)
            .resizable().aspectRatio(contentMode: .fit)
    }
}

#Preview {
    PhaseAsyncImage(imageUrl: URL(string: "https://picsum.photos/400"))
}
