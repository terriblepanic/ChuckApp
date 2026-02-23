//
//  ContentView.swift
//  Chuck
//
//  Created by Кирилл Паничкин on 2/24/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RandomQuoteView()
                .tabItem {
                    Label("Цитата", systemImage: "bolt.fill")
                }

            AllQuotesView()
                .tabItem {
                    Label("Все цитаты", systemImage: "list.bullet")
                }

            CategoriesView()
                .tabItem {
                    Label("Категории", systemImage: "folder.fill")
                }
        }
        .tint(.orange)
    }
}
