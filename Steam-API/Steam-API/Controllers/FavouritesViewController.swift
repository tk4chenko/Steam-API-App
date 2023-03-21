//
//  FavouritesViewController.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import UIKit
import RealmSwift

class FavouritesViewController: UIViewController {
    
    let realm = try! Realm()
    var favourites: Results<PlayerObject>!

    @IBOutlet weak var favouritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favourites = realm.objects(PlayerObject.self)
        favouritesTableView.reloadData()
    }

}

extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = favourites.reversed()[indexPath.row].username
        return cell
    }

}
