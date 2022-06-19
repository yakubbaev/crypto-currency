//
//  FavoriteCoinsManager.swift
//  CryptoCurrency
//
//  Created by Mukhammad Yakubbaev on 19/06/22.
//

import Foundation

protocol FavoriteCoinsSubscriberProtocol {

    func favoriteCoinsDidChange(coins: [Coin])

}

protocol FavoriteCoinsPublisherProtocol {

    mutating func subscribe(_ subscriber: FavoriteCoinsSubscriberProtocol)

}

protocol FavoriteCoinsManagerProtocol: FavoriteCoinsPublisherProtocol, FavoriteCoinsRepoProtocol {

}

struct FavoriteCoinsManager: FavoriteCoinsManagerProtocol {

    // MARK: Singleton
    
    static var shared = FavoriteCoinsManager(repo: FavoriteCoinsRepo())

    private init(repo: FavoriteCoinsRepoProtocol) {

        self.repo = repo

    }

    // MARK: - FavoriteCoinsPublisherProtocol

    private var subscribers: [FavoriteCoinsSubscriberProtocol] = []

    mutating func subscribe(_ subscriber: FavoriteCoinsSubscriberProtocol) {

        subscribers.append(subscriber)

    }

    func notify() {

        let coins = repo.loadFavorites() ?? []

        for subscriber in subscribers {

            subscriber.favoriteCoinsDidChange(coins: coins)

        }

    }

    // MARK: - FavoriteCoinsRepoProtocol

    private var repo: FavoriteCoinsRepoProtocol

    func saveFavorites(coins: [Coin]) {

        repo.saveFavorites(coins: coins)
        notify()

    }

    func loadFavorites() -> [Coin]? {

        repo.loadFavorites()

    }

}
