//
//  CoinListPresenter.swift
//  Meera_Task
//
//  Created by Meera Seetharam on 29/11/24.
//

import Foundation

protocol CoinListPresenterInputProtocol: AnyObject {
    func viewDidLoad()
    func search(query: String)
    func applyFilter(isActive: Bool?, type: CryptoType?, isNew: Bool?)
}

protocol CoinListPresenterOutputProtocol: AnyObject {
    func showCoins(coins: [Coin])
    func showError(error: String)
}

class CoinListPresenter: CoinListPresenterInputProtocol {
    
    weak var view: CoinListPresenterOutputProtocol?
    private let interactor: CoinListInteractor

    init(interactor: CoinListInteractor) {
        self.interactor = interactor
        interactor.output = self
    }

    func viewDidLoad() {
        interactor.fetchCoins()
    }

    func search(query: String) {
        interactor.searchCoins(query: query)
    }

    func applyFilter(isActive: Bool?, type: CryptoType?, isNew: Bool?) {
        interactor.applyFilter(isActive: isActive, type: type, isNew: isNew)
    }
}

extension CoinListPresenter: CoinListInteractorOutputProtocol {
    func coinsFetched(coins: [Coin]) {
        self.view?.showCoins(coins: coins)
    }
    
    func searchResults(coins: [Coin]) {
        self.view?.showCoins(coins: coins)
    }
    
    func showError(error: any Error) {
        //
    }
}

