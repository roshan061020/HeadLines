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
                .onChange(of: viewModel.selectedCategory) { oldValue,newValue in
                    if oldValue != newValue{
                        viewModel.articles = []
                        viewModel.fetchArticles()
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading articles...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.errorMessage != nil {
                    errorWithReTry
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.articles.isEmpty {
                    ContentUnavailableView("No articles available.", systemImage: "xmark.circle")
                        .symbolRenderingMode(.multicolor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.title)
                        .foregroundStyle(.secondary)
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

