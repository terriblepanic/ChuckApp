//
//  CategoriesView.swift
//  Chuck
//
//  Created by Кирилл Паничкин on 2/24/26.
//

import SwiftUI
import RealmSwift

struct CategoriesView: View {
    @ObservedResults(QuoteCategory.self, sortDescriptor: SortDescriptor(keyPath: "name"))
    var categories

    var body: some View {
        NavigationStack {
            Group {
                if categories.isEmpty {
                    emptyState
                } else {
                    List(categories) { category in
                        NavigationLink {
                            CategoryQuotesView(categoryName: category.name)
                        } label: {
                            CategoryRow(category: category)
                        }
                    }
                }
            }
            .navigationTitle("Категории")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder")
                .font(.system(size: 52, weight: .thin))
                .foregroundColor(.orange.opacity(0.6))
            Text("Нет категорий")
                .font(.title3.weight(.semibold))
            Text("Загрузите несколько цитат\nчтобы увидеть категории")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct CategoryRow: View {
    let category: QuoteCategory

    var body: some View {
        HStack {
            Image(systemName: category.name == "без категории" ? "questionmark.folder" : "folder.fill")
                .foregroundColor(.orange)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(category.name.isEmpty ? "без категории" : category.name)
                    .font(.body.weight(.medium))
                Text("\(category.quotes.count) цитат")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CategoryQuotesView: View {
    let categoryName: String

    @ObservedResults(Quote.self, sortDescriptor: SortDescriptor(keyPath: "downloadDate", ascending: false))
    var allQuotes

    private var filteredQuotes: Results<Quote> {
        allQuotes.filter("categoryName == %@", categoryName)
    }

    var body: some View {
        List(filteredQuotes) { quote in
            QuoteRow(quote: quote)
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if filteredQuotes.isEmpty {
                ContentUnavailableView("Нет цитат", systemImage: "text.bubble")
            }
        }
    }
}
