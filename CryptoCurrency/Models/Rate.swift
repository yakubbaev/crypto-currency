//
//  Rate.swift
//  CryptoCurrency
//
//  Created by Mukhammad Yakubbaev on 18/06/22.
//

import Foundation

struct Rate {

    var coin: Coin
    var prices: [Currency: Double]

}

extension Rate {

    var displayPrices: String {

        prices.map { (key: Currency, value: Double) in
            "\(key): \(value)"
        }
        .joined(separator: ", ")

    }

}
