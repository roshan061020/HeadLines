//
//  ShortNewsApp.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import SwiftUI

@main
struct ShortNewsApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NewsListView()
                    .tabItem {
                        Label("Headlines", systemImage: "newspaper")
                    }
                BookmarkView()
                    .tabItem {
                        Label("BookMarks", systemImage: "bookmark")
                    }
            }
            .task {
                ArticleRepository().cleanUpArticles()
            }
            .onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}
