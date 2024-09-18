//
//  BookmarkView.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import SwiftUI

struct BookmarkView: View {
    @StateObject private var viewModel = BookmarkViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if !viewModel.bookmarkedArticles.isEmpty {
                    List(viewModel.bookmarkedArticles, id: \.url) { article in
                        NavigationLink(destination: NewsDetailView(articleURL: article.url)) {
                            HStack {
                                
                                AsyncImage(url: article.imageUrl) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 80, height: 80)
                                .aspectRatio(contentMode: .fit)
                                
                                
                                VStack(alignment: .leading) {
                                    Text(article.title)
                                        .font(.headline)
                                    Text(article.category.capitalized)
                                        .font(.subheadline)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                }
                            }
                        }
                    }
                } else {
                    Text("No bookmarked articles.")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Bookmarks")
            .onAppear {
                viewModel.fetchBookmarkedArticles()
            }
        }
    }
}

