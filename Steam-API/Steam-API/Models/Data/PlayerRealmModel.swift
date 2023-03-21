//
//  RealmModels.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import Foundation
import RealmSwift

class PlayerObject: Object {
    @Persisted(primaryKey: true) var id: String?
    @Persisted var comment: String?
    @Persisted var meta: MetaObject?
    @Persisted var avatar: String?
    @Persisted var username: String?
}

class MetaObject: Object {
    @Persisted(primaryKey: true) var steamid: String?
    @Persisted var profileurl: String?
}
