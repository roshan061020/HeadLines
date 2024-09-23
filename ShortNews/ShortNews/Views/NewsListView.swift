//
//  NewsListView.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel = NewsListViewModel()
    
    var body: some View {
        NavigationView {
            VStack() {
                SelectableChipsView(data: CategoryType.allCases.map{$0.rawValue},
                                    selectedChips: $viewModel.selectedCategory)
                .padding()
                .onChange(of: viewModel.selectedCategory) { _ in
                        viewModel.articles = []
                        viewModel.fetchArticles()
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading articles...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.errorMessage != nil {
                    errorWithReTry
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.articles.isEmpty {
                    ContentNotAvailableView(systemImageName: "xmark.circle", message: "No articles available.")
                } else {
                    List(viewModel.articles) { article in
                        NavigationLink {
                            NewsDetailView(articleURL: article.url)
                        } label: {
                            NewsRowView(article: article)
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                }
            }
            .task {
                viewModel.fetchArticles()
            }
            .navigationTitle("Headlines")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var errorWithReTry: some View {
        VStack {
            Text(viewModel.errorMessage ?? "")
                .font(.title)
                .foregroundColor(.red)
                .padding()
            Button("Retry") {
                viewModel.articles = []
                viewModel.fetchArticles()
            }
        }
    }
}


struct ContentNotAvailableView: View {
    var systemImageName: String
    var message: String
    var body: some View {
        VStack {
            Image(systemName: systemImageName)
                .symbolRenderingMode(.multicolor)
            
            Text(message)
                .font(.title)
        }
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
