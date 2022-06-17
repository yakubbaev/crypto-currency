//
//  CoinsApi.swift
//  CryptoCurrency
//
//  Created by Mukhammad Yakubbaev on 17/06/22.
//

import Foundation

protocol CoinsApiProtocol {

    func getAvailable(completionHandler: @escaping (([Coin]) -> Void))

}

struct CoinsApi: CoinsApiProtocol {

    func getAvailable(completionHandler: @escaping (([Coin]) -> Void)) {
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/blockchain/list?auth_key=9a366d4e021c2260032ebc9f36e17d3245cfd3fbcf4ac8e19b64a18bc237ee75") else {
            print("Failed to create url to load coins")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Failed to load coins: \(error)")
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Failed to parse coins")
                return
            }
            guard let coinsData = json["Data"] as? [String: Any] else {
                print("Failed to get 'Data' field from json")
                return
            }
            let coinsArray = Array(coinsData.keys).sorted()
            completionHandler(coinsArray)

        }
        task.resume()
    }

}
