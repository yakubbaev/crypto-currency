//
//  RatesApi.swift
//  CryptoCurrency
//
//  Created by Mukhammad Yakubbaev on 18/06/22.
//

import Foundation

protocol RatesApiProtocol {

    func loadRates(for coins: [Coin], completionHandler: @escaping (([Rate]) -> Void))

}

struct RatesApi: RatesApiProtocol {

    func loadRates(for coins: [Coin], completionHandler: @escaping (([Rate]) -> Void)) {

        let fromSymbols = coins.joined(separator: ",")
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(fromSymbols)&tsyms=USD,EUR") else {
            print("Failed to create url to load rates")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Failed to load rates \(error)")
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Coin: Any] else {
                print("Failed to parse rates")
                return
            }

            var result: [Rate] = []
            for (coin, rateJson) in json {

                guard let rateJson = rateJson as? [String: Double] else {
                    print("Failed to parse rates dict")
                    return
                }
                for (currency, price) in rateJson {
                    guard let currency = Currency(rawValue: currency) else {
                        print("Failed to parse rates currency")
                        return
                    }
                    let rate = Rate(coin: coin, currency: currency, price: price)
                    result.append(rate)
                }

            }
            completionHandler(result)

        }
        task.resume()

    }

}
