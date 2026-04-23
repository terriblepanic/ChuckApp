//
//  RandomQuoteView.swift
//  Chuck
//
//  Created by Кирилл Паничкин on 2/24/26.
//

import SwiftUI
import RealmSwift

struct RandomQuoteView: View {
    @State private var currentQuote: Quote? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var savedJustNow = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.orange)

                Group {
                    if let quote = currentQuote {
                        VStack(spacing: 12) {
                            Text("\u{201C}\(quote.text)\u{201D}")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)

                            HStack(spacing: 4) {
                                Image(systemName: "tag.fill")
                                    .font(.caption)
                                Text(quote.categoryName)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())

                            if savedJustNow {
                                Label("Сохранено в базу данных", systemImage: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    } else {
                        Text("Нажмите «Загрузить»\nчтобы получить цитату Чака Норриса")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                }
                .frame(minHeight: 150)

                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Spacer()

                Button {
                    Task { await loadQuote() }
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "arrow.down.circle.fill")
                        }
                        Text("Загрузить")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isLoading ? Color.gray : Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(isLoading)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .navigationTitle("Цитата дня")
        }
    }

    private func loadQuote() async {
        isLoading = true
        errorMessage = nil
        savedJustNow = false

        do {
            let response = try await ChuckNetworkService.shared.fetchRandomQuote()

            RealmService.shared.save(response: response)

            let categoryName = response.categories.first ?? "без категории"
            let quote = Quote(id: response.id, text: response.value, categoryName: categoryName, iconURL: response.iconURL)

            await MainActor.run {
                currentQuote = quote
                savedJustNow = true
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}
