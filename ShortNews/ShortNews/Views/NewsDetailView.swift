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
                    Text(newsDetailViewModel.article?.content ?? "").font(.subheadline)
                }
                .padding([.horizontal, .top])
            }
            
            Button(action: {
                if let url = newsDetailViewModel.article?.url {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Read More")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .clipShape(.buttonBorder)
                    .padding([.horizontal, .bottom])
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    newsDetailViewModel.toggleBookmark()
                }) {
                    newsDetailViewModel.article?.isBookmarked == true 
                    ? Image(systemName: "bookmark.fill")
                    : Image(systemName: "bookmark")
                }.padding()
            }
        })
        .task{
            newsDetailViewModel.fetchArticle(for: articleURL)
        }
    }
}

