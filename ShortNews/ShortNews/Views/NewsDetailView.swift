//
//  NewsDetailView.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import SwiftUI

struct NewsDetailView: View {
    let articleURL: URL
    @StateObject var newsDetailViewModel = NewsDetailViewModel()
    
    var body: some View {
        VStack{
            ScrollView {
                PhaseAsyncImage(imageUrl: newsDetailViewModel.article?.imageUrl)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(alignment: .bottom) {
                        ZStack(alignment: .trailing){
                            if let publishedAt = newsDetailViewModel.article?.publishedAt {
                                HStack{
                                    Spacer()
                                    Text(publishedAt.ToString())
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.8))
                    }
                VStack(spacing: 10) {
                    Text(newsDetailViewModel.article?.title ?? "").font(.title2).bold()
                    Text(newsDetailViewModel.article?.subtitle ?? "").font(.headline)
                        .lineLimit(nil)
                    Text(newsDetailViewModel.article?.content ?? "").font(.subheadline)
                }
                .padding([.horizontal, .top])
            }
            
            RoundedButton(title: "Read More") {
                if let url = newsDetailViewModel.article?.url {
                    UIApplication.shared.open(url)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        newsDetailViewModel.toggleBookmark()
                    }) {
                        newsDetailViewModel.article?.isBookmarked == true
                        ? Image(systemName: StringConstants.systemImageName.bookmarkFill)
                        : Image(systemName: StringConstants.systemImageName.bookmark)
                    }.padding()
                }
            })
            .task{
                newsDetailViewModel.fetchArticle(for: articleURL)
            }
        }
    }
}
