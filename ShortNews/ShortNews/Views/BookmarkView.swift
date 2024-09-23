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
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView()
                } else if !viewModel.bookmarkedArticles.isEmpty {
                    List(viewModel.bookmarkedArticles, id: \.url) { article in
                        NavigationLink(destination: NewsDetailView(articleURL: article.url)) {
                            HStack {
                                PhaseAsyncImage(imageUrl: article.imageUrl,
                                                imageWidth: 75,
                                                height: 75,
                                                contentMode: .fit)
                                VStack(alignment: .leading, spacing: 20) {
                                    Text(article.title)
                                        .font(.headline)
                                    Text(article.category.capitalized)
                                        .font(.subheadline)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
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

