//
//  AllQuotesView.swift
//  Chuck
//
//  Created by Кирилл Паничкин on 2/24/26.
//

import SwiftUI
import RealmSwift

struct AllQuotesView: View {
    @ObservedResults(Quote.self, sortDescriptor: SortDescriptor(keyPath: "downloadDate", ascending: false))
    var quotes

    var body: some View {
        NavigationStack {
            Group {
                if quotes.isEmpty {
                    emptyState
                } else {
                    List(quotes) { quote in
                        QuoteRow(quote: quote)
                    }
                }
            }
            .navigationTitle("Все цитаты")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "text.bubble")
                .font(.system(size: 52, weight: .thin))
                .foregroundColor(.orange.opacity(0.6))
            Text("Нет сохранённых цитат")
                .font(.title3.weight(.semibold))
            Text("Перейдите на первую вкладку\nи загрузите цитату")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct QuoteRow: View {
    let quote: Quote

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: quote.downloadDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quote.text)
                .font(.subheadline)
                .lineLimit(4)

            HStack {
                Label(quote.categoryName, systemImage: "tag")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text(formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
