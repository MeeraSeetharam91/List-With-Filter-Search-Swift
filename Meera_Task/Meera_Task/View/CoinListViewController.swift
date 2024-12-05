//
//  CoinListViewController.swift
//  Meera_Task
//
//  Created by Meera Seetharam on 30/11/24.
//

import UIKit

class CoinListViewController: UIViewController {
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var coinListTableView: UITableView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var dataSource = [Coin]()
    var filterDataSource = [FilterSelection]()
    
    private let presenter = CoinListPresenter(interactor: CoinListInteractor.init(coinRepository: CoinDataSource()))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.view = self
        presenter.viewDidLoad()
        self.setUpView()
    }

    func setUpView() {
        self.titlelabel.text = "COIN"

        coinListTableView.dataSource = self
        coinListTableView.delegate = self
        coinListTableView.register(UINib(nibName: CoinListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CoinListTableViewCell.identifier)
        
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)

        for type in Filter.allCases {
            filterDataSource.append(FilterSelection(filterType: type))
        }
        filterCollectionView.reloadData()
    }
    
    func refreshData() {
        var isActive: Bool?
        var type: CryptoType?
        var isNew: Bool?
        
        for item in filterDataSource {
            switch item.filterType {
            case .active:
                if item.isSelected {
                    if let active = isActive {
                        isActive = active == false ? nil : active
                    } else {
                        isActive = true
                    }
                }
            case .inactive:
                if item.isSelected {
                    if let active = isActive {
                        isActive = active == false ? nil : active
                    } else {
                        isActive = false
                    }
                }
            case .tokenOnly:
                if item.isSelected {
                    if let cryptoType = type {
                        type = cryptoType == .coin ? nil : cryptoType
                    } else {
                        type = .token
                    }
                }
            case .coinOnly:
                if item.isSelected {
                    if let cryptoType = type {
                        type = cryptoType == .token ? nil : cryptoType
                    } else {
                        type = .coin
                    }
                }
            case .new:
                if item.isSelected {
                    if let new = isNew {
                        isNew = !new
                    } else {
                        isNew = true
                    }
                } else {
                    isNew = nil
                }
            }
        }
        self.presenter.applyFilter(isActive: isActive, type: type, isNew: isNew)
    }
}
//MARK: TableView delegates
extension CoinListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinListTableViewCell.identifier, for: indexPath) as? CoinListTableViewCell else { return UITableViewCell() }
        return cell
    }
    
}

extension CoinListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let theCell = cell as? CoinListTableViewCell else {
            return
        }
        theCell.setData(model: dataSource[indexPath.row])
    }
}

//MARK: CollectionView delegates
extension CoinListViewController: CoinListPresenterOutputProtocol {
    func showCoins(coins: [Coin]) {
        dataSource = coins
        DispatchQueue.main.async {
            self.coinListTableView.reloadData()
            self.filterCollectionView.reloadData()
        }
    }
    
    func showError(error: String) {
        //
    }
}

extension CoinListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension CoinListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let theCell = cell as? FilterCollectionViewCell else {
            return
        }
        theCell.setData(model: filterDataSource[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isSelected = filterDataSource[indexPath.row].isSelected
        filterDataSource[indexPath.row].isSelected = !isSelected
        refreshData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = filterDataSource[indexPath.row]
        var width = item.filterType.rawValue.size(with: UIFont.systemFont(ofSize: 12)).width + 26
        if item.isSelected {
            width += 26
        }
        return CGSize(width: width, height: 30)
    }
}
