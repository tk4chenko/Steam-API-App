//
//  ViewController.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var popUp: PopUpView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = UIColor.systemBackground
    }
    
    private func animateIn() {
        guard let popUp = self.popUp else { return }
        self.view.addSubview(popUp)
        popUp.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        popUp.alpha = 0
        popUp.center = self.view.center
        UIView.animate(withDuration: 0.3 ) {
            popUp.transform = CGAffineTransform(scaleX: 1, y: 1)
            popUp.alpha = 1
        }
    }
    
    func animateOut() {
        guard let popUp = self.popUp else { return }
        UIView.animate(withDuration: 0.3, animations: {
            popUp.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            popUp.alpha = 0
        }, completion: { _ in
            popUp.removeFromSuperview()
        })
    }
    
    func addAllert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        dialogMessage.view.tintColor = .red
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let nickname = searchBar.text else { return }
        networkManager.fetchData(nickname) { result in
            switch result {
            case .success(let value):
                self.popUp = PopUpView()
                self.popUp?.configure(value)
                self.popUp?.delegate = self
                self.animateIn()
            case .failure(_):
                self.addAllert(title: "Error", message: "No Internet connection.")
            }
            searchBar.text = ""
            self.view.endEditing(true)
        }
    }
}

extension SearchViewController: PopViewDelegate {
    func presentWebView(_ url: URL) {
        let viewController = WebViewController(with: url)
        present(viewController, animated: true)
    }
}
