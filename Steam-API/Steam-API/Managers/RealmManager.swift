//
//  RealmManager.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static var shared = RealmManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func save(_ player: Steam.DataClass.Player) {
        let playerObject = PlayerObject()
        playerObject.id = player.id
        playerObject.username = player.username
        playerObject.avatar = player.avatar
        playerObject.comment = player.comment
        
        try! realm.write {
            realm.add(playerObject, update: .all)
        }
    }
    
}
