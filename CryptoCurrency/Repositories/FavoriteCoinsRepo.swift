//
//  FavoriteCoinsRepo.swift
//  CryptoCurrency
//
//  Created by Mukhammad Yakubbaev on 18/06/22.
//

import Foundation

protocol FavoriteCoinsRepoProtocol {

    func saveFavorites(coins: [Coin]);
    func loadFavorites() -> [Coin]?
    
}


struct FavoriteCoinsRepo: FavoriteCoinsRepoProtocol {

    static let FAVORITE_COINS_KEY = "favorite_coins"

    func saveFavorites(coins: [Coin]) {

        UserDefaults.standard.setValue(coins, forKey: FavoriteCoinsRepo.FAVORITE_COINS_KEY)
        
    }

    func loadFavorites() -> [Coin]? {

        return UserDefaults.standard.array(forKey: FavoriteCoinsRepo.FAVORITE_COINS_KEY) as? [Coin]

    }
}
