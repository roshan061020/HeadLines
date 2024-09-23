//
//  NewsListView.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import SwiftUI

struct NewsListView: View {
    @Environment(\.colorScheme) var colorScheme
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
                    ProgressView("Loading \(viewModel.selectedCategory) articles...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.errorMessage != nil {
                    errorWithReTry
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.articles.isEmpty {
                    ContentNotAvailableView(systemImageName: StringConstants.systemImageName.xCircle,
                                            message: "No articles available.")
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
            Button {
                viewModel.articles = []
                viewModel.fetchArticles()
            } label: {
                HStack {
                    Image(systemName: StringConstants.systemImageName.retry)
                    Text("Retry")
                }
            }

            Text(viewModel.errorMessage ?? "")
                .font(.subheadline)
                .foregroundColor(colorScheme == .dark ? .blue : .red)
                .padding()
                .padding(.horizontal)
            
        }
    }
}
