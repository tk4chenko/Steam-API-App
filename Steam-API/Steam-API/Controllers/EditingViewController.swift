//
//  EditingViewController.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 22.03.2023.
//

import UIKit

protocol ReloadDelegate: AnyObject {
    func reloadTableView()
}

final class EditingViewController: UIViewController {
    
    // MARK: Properties
    
    var player: PlayerObject?
    
    weak var delegate: ReloadDelegate?
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        return textView
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    // MARK: Actions
    
    @objc private func editButtonTapped() {
        let newComment = commentTextView.text ?? ""
        guard let player = self.player else { return }
        RealmManager.shared.changeComment(player, newComment)
        delegate?.reloadTableView()
        self.dismiss(animated: true)
    }
    
    // MARK: Setup
    
    private func setupNavBar() {
        title = "Edit message"
        let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        edit.tintColor = .systemIndigo
        navigationItem.rightBarButtonItem = edit
    }
    private func setupConstraints() {
        view.addSubview(commentTextView)
        NSLayoutConstraint.activate([
            commentTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            commentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            commentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            commentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}
