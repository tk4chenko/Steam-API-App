//
//  NetworkManager.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetchData(_ nickname: String, completion: @escaping (Steam.DataClass.Player) -> Void)
}

struct NetworkManager: NetworkManagerProtocol {
    
    func fetchData(_ nickname: String, completion: @escaping (Steam.DataClass.Player) -> Void) {
        AF.request("https://playerdb.co/api/player/steam/\(nickname)").responseDecodable(of: Steam.self) { response in
            switch response.result {
            case .success(let value):
                guard let data = value.data?.player else { return }
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
