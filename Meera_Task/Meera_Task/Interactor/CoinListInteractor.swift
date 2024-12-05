//
//  CoinListInteractor.swift
//  Meera_Task
//
//  Created by Meera Seetharam on 29/11/24.
//

import Foundation

protocol CoinListInteractorInputProtocol {
    func fetchCoins()
    func searchCoins(query: String)
    func applyFilter(isActive: Bool?, type: CryptoType?, isNew: Bool?)
}

protocol CoinListInteractorOutputProtocol: AnyObject {
    func coinsFetched(coins: [Coin])
    func searchResults(coins: [Coin])
    func showError(error: Error)
}

class CoinListInteractor: CoinListInteractorInputProtocol {
    weak var output: CoinListInteractorOutputProtocol?
    private let coinRepository: CoinRepository

    init(coinRepository: CoinRepository) {
        self.coinRepository = coinRepository
    }

    func fetchCoins() {
        Task {
            do {
                let coins = try await coinRepository.fetchCoinsFromFile()
                output?.coinsFetched(coins: coins)
            } catch {
                output?.showError(error: error)
            }
        }
    }

    func searchCoins(query: String) {
        // Implement search logic using the coinRepository
    }
    
    func applyFilter(isActive: Bool?, type: CryptoType?, isNew: Bool?) {
        Task {
            do {
                var coins = try await coinRepository.fetchCoinsFromFile()
                if let active = isActive {
                    coins = coins.filter({ $0.isActive == active })
                }
                if let typeSelected = type {
                    coins = coins.filter({ $0.cryptoType == typeSelected })
                }
                if let new = isNew {
                    coins = coins.filter({ $0.isNew == new })
                }
                output?.coinsFetched(coins: coins)
            } catch {
                output?.showError(error: error)
            }
        }
    }

}
