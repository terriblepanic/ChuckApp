//
//  ChuckNetworkService.swift
//  Chuck
//
//  Created by Кирилл Паничкин on 2/24/26.
//

import Foundation

struct ChuckQuoteResponse: Decodable {
    let id: String
    let value: String
    let categories: [String]
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case id, value, categories
        case iconURL = "icon_url"
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:       return "Неверный URL"
        case .decodingError(let e): return "Ошибка разбора данных: \(e.localizedDescription)"
        case .networkError(let e):  return "Сетевая ошибка: \(e.localizedDescription)"
        }
    }
}

final class ChuckNetworkService {
    static let shared = ChuckNetworkService()
    private init() {}

    private let randomURL = URL(string: "https://api.chucknorris.io/jokes/random")!

    func fetchRandomQuote() async throws -> ChuckQuoteResponse {
        let (data, _) = try await URLSession.shared.data(from: randomURL)
        do {
            return try JSONDecoder().decode(ChuckQuoteResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
