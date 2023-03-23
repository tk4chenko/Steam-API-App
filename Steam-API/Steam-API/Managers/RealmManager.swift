//
//  RealmManager.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    // MARK: Singleton
        
    static let shared = RealmManager()
        
    // MARK: Properties
    
    let realm = try! Realm()
    
    var favourites: Results<PlayerObject>! {
        return realm.objects(PlayerObject.self)
    }
    
    // MARK: Initializer
    
    private init() {}
    
    // MARK: Public Methods
    
    func save(_ player: Steam.DataClass.Player) {
        let playerObject = PlayerObject()
        playerObject.id = player.id
        playerObject.username = player.username
        playerObject.avatar = player.avatar
        playerObject.comment = player.comment
        do {
            try realm.write {
                realm.add(playerObject, update: .all)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func delete(_ player: PlayerObject) {
        do {
            try realm.write {
                realm.delete(player)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func changeComment(_ object: PlayerObject, _ comment: String) {
        do {
            try realm.write {
                object.comment = comment
                realm.add(object, update: .modified)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
