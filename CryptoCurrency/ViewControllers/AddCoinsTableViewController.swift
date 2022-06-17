//
//  AddCoinsTableViewController.swift
//  CryptoCurrency
//
//  Created by Mukhammad Yakubbaev on 17/06/22.
//

import UIKit

class AddCoinsTableViewController: UITableViewController {

    var api: CoinsApiProtocol = CoinsApi()
    var coins: [Coin] = []
    var filteredCoins: [Coin] = []
    var selectedCoins: [Coin] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        api.getAvailable { result in
            self.coins = result
            self.filteredCoins = self.coins
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coin", for: indexPath)

        let coin = self.filteredCoins[indexPath.row]
        cell.textLabel?.text = coin
        cell.accessoryType = selectedCoins.contains(coin) ? .checkmark : .none

        return cell
    }

    // MARK: Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let coin = self.filteredCoins[indexPath.row]
        if let index = selectedCoins.firstIndex(of: coin) {
            selectedCoins.remove(at: index)
        } else {
            selectedCoins.append(coin)
        }
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}

extension AddCoinsTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredCoins = coins.filter({ coin in
            coin.starts(with: searchText)
        })
        self.tableView.reloadData()
    }
}
