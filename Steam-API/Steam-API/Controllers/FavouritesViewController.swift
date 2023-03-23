//
//  FavouritesViewController.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import UIKit

final class FavouritesViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var favouritesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    let realmManager = RealmManager.shared
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesTableView.reloadData()
    }
    
    // MARK: Private Methods
    
    private func setupTableView() {
        view.addSubview(favouritesTableView)
        favouritesTableView.frame = view.bounds
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        favouritesTableView.register(FavouriteTableViewCell.self, forCellReuseIdentifier: FavouriteTableViewCell.identifier)
    }
    
    private func presentModal(_ indexPath: IndexPath) {
        let viewController = EditingViewController()
        viewController.delegate = self
        viewController.player = realmManager.favourites.reversed()[indexPath.row]
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationController?.title = "Edit message"
        viewController.commentTextView.text = realmManager.favourites.reversed()[indexPath.row].comment
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        let cancel = UIBarButtonItem(systemItem: .cancel)
        navigationController.navigationItem.rightBarButtonItem = cancel
        present(navigationController, animated: true)
    }
}

// MARK: - ReloadDelegate

extension FavouritesViewController: ReloadDelegate {
    func reloadTableView() {
        favouritesTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        realmManager.favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.identifier, for: indexPath) as? FavouriteTableViewCell else { return UITableViewCell() }
        cell.configureCell(realmManager.favourites.reversed()[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmManager.shared.delete(realmManager.favourites.reversed()[indexPath.row])
            favouritesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentModal(indexPath)
    }
}
