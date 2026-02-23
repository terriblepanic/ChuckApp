//
//  RealmService.swift
//  Chuck
//
//  Created by Кирилл Паничкин on 2/24/26.
//

import Foundation
import RealmSwift

final class RealmService {
    static let shared = RealmService()

    private let realm: Realm

    private init() {
        let config = Realm.Configuration(schemaVersion: 1)
        realm = try! Realm(configuration: config)
    }

    // MARK: - Сохранение

    func save(response: ChuckQuoteResponse) {
        guard realm.object(ofType: Quote.self, forPrimaryKey: response.id) == nil else {
            return
        }

        let categoryName = response.categories.first ?? "без категории"

        let quote = Quote(
            id: response.id,
            text: response.value,
            categoryName: categoryName,
            iconURL: response.iconURL
        )

        try? realm.write {
            let category: QuoteCategory
            if let existing = realm.object(ofType: QuoteCategory.self, forPrimaryKey: categoryName) {
                category = existing
            } else {
                category = QuoteCategory(name: categoryName)
                realm.add(category)
            }
            realm.add(quote)
            category.quotes.append(quote)
        }
    }

    // MARK: - Чтение

    func allQuotes() -> Results<Quote> {
        return realm.objects(Quote.self).sorted(byKeyPath: "downloadDate", ascending: false)
    }

    func allCategories() -> Results<QuoteCategory> {
        return realm.objects(QuoteCategory.self).sorted(byKeyPath: "name")
    }

    func quotes(for category: QuoteCategory) -> Results<Quote> {
        return realm.objects(Quote.self)
            .filter("categoryName == %@", category.name)
            .sorted(byKeyPath: "downloadDate", ascending: false)
    }
}
