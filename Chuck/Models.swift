//
//  Models.swift
//  Chuck
//
//  Created by Кирилл Паничкин on 2/24/26.
//

import Foundation
import RealmSwift

final class QuoteCategory: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var name: String = ""
    @Persisted var quotes: List<Quote>

    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

final class Quote: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var text: String = ""
    @Persisted var categoryName: String = ""
    @Persisted var downloadDate: Date = Date()
    @Persisted var iconURL: String = ""

    convenience init(id: String, text: String, categoryName: String, iconURL: String) {
        self.init()
        self.id = id
        self.text = text
        self.categoryName = categoryName
        self.downloadDate = Date()
        self.iconURL = iconURL
    }
}
