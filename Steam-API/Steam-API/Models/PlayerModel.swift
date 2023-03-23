//
//  PlayerModel.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import Foundation

struct Steam: Decodable {
    let code, message: String?
    let data: DataClass?
    let success: Bool?
    let error: Bool?
}

extension Steam {
    struct DataClass: Decodable {
        let player: Player?
    }
}

extension Steam.DataClass {
    struct Player: Decodable {
        var comment: String?
        let meta: Meta?
        let id: String?
        let avatar: String?
        let username: String?
    }
}

extension Steam.DataClass.Player {
    struct Meta: Decodable {
        let steamid: String?
        let profileurl: String?
    }
}
