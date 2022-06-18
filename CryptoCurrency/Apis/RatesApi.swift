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
                print("Failed to load rates \(String(describing: error))")
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Coin: Any] else {
                print("Failed to parse rates")
                return
            }

            var result: [Rate] = []
            for (coin, prices) in json {

                guard let pricesJson = prices as? [String: Double] else {
                    print("Failed to parse rate prices")
                    return
                }
                var prices: [Currency: Double] = [:]
                for (key, value) in pricesJson {
                    guard let currency = Currency(rawValue: key) else {
                        print("Failed to parse rate currency")
                        return
                    }
                    prices[currency] = value
                }
                let rate = Rate(coin: coin, prices: prices)
                result.append(rate)

            }
            completionHandler(result)

        }
        task.resume()

    }

}
