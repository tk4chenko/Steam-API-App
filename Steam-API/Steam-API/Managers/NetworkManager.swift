//
//  NetworkManager.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetchData(_ nickname: String, completion: @escaping (Result<Steam.DataClass.Player?, Error>) -> Void)
}

struct NetworkManager: NetworkManagerProtocol {
    
    func fetchData(_ nickname: String, completion: @escaping (Result<Steam.DataClass.Player?, Error>) -> Void) {
        AF.request("https://playerdb.co/api/player/steam/\(nickname)").responseDecodable(of: Steam.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value.data?.player))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
}
