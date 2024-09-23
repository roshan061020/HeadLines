//
//  NewsRowView.swift
//  Headlines
//
//  Created by Roshan yadav on 18/09/24.
//

import SwiftUI

struct NewsRowView: View {
   
    let article: NewsArticle
    let publishedTextPrefix = "Published At:"
    
    var body: some View {
        VStack {
            PhaseAsyncImage(imageUrl: article.imageUrl)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading) {
                Text(article.title).bold()
                Text(article.subtitle ?? "")
                    .lineLimit(3)
                if let publishedAt = article.publishedAt {
                    HStack{
                        Text(publishedTextPrefix)
                        Text(publishedAt.ToString())
                            .fontWeight(.bold)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
        }
    }
}
