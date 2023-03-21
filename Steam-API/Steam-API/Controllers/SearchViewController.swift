//
//  ViewController.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var popUp: PopUpView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        searchBar.delegate = self
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.darkBlue.cgColor, UIColor.lightBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func animateIn() {
        guard let popUp = self.popUp else { return}
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
        guard let popUp = self.popUp else { return}
        UIView.animate(withDuration: 0.3, animations: {
            popUp.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            popUp.alpha = 0
        }, completion: { _ in
            popUp.removeFromSuperview()
        })
    }
    

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let nickname = searchBar.text else { return }
        networkManager.fetchData(nickname) { player in
            self.popUp = PopUpView()
            self.popUp?.delegate = self
            self.popUp?.configure(player)
            self.animateIn()
            searchBar.text = ""
        }
    }
}

extension SearchViewController: PopViewDelegate {
    func presentWebView(_ url: URL) {
        let viewController = WebViewController(with: url)
        present(viewController, animated: true)
    }
}
