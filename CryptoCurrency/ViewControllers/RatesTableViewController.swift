//
//  RatesTableViewController.swift
//  CryptoCurrency
//
//  Created by Mukhammad Yakubbaev on 17/06/22.
//

import UIKit

class RatesTableViewController: UITableViewController {

    var repo: FavoriteCoinsRepoProtocol = FavoriteCoinsRepo()
    var favoriteCoins: [Coin] = []
    var api: RatesApiProtocol = RatesApi()
    var rates: [Rate] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        favoriteCoins = repo.loadFavorites() ?? []

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reloadRates), for: .valueChanged)

        refreshControl?.beginRefreshing()
        reloadRates()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return rates.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "rate", for: indexPath)
        let rate = rates[indexPath.row]
        cell.textLabel?.text = rate.coin
        cell.detailTextLabel?.text = rate.displayPrices

        return cell

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let vc = segue.destination as? AddCoinsTableViewController {

            vc.delegate = self

        }

    }

}

extension RatesTableViewController: AddCoinsTableViewControllerDelegate {

    func coinsDidChange(_ coins: [Coin]) {

        self.favoriteCoins = coins
        reloadRates()

    }

}

extension RatesTableViewController {

    @objc func reloadRates() {

        api.loadRates(for: favoriteCoins) { result in

            self.rates = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }

        }

    }

}
