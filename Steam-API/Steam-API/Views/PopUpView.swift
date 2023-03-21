//
//  PopUp.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import UIKit
import SDWebImage

protocol PopViewDelegate: AnyObject {
    func animateOut()
    func presentWebView(_ url: URL)
}

class PopUpView: UIView {
    
    weak var delegate: PopViewDelegate?
    private var player: Steam.DataClass.Player?
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter comment here"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addBlur(.systemThinMaterialDark)
        return view
    }()
    
    private lazy var closedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.tintColor = .blue
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var addToFavouritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 8
        button.setTitle("Add to favorites", for: .normal)
        button.addTarget(self, action: #selector(addToFavourites), for: .touchUpInside)
        return button
    }()
    
    private lazy var openWebViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 8
        button.setTitle("Open web view", for: .normal)
        button.addTarget(self, action: #selector(openWebView(_:)), for: .touchUpInside)
        return button
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .systemIndigo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 240))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        delegate?.animateOut()
    }
    
    @objc private func addToFavourites() {
        print(commentTextField.text ?? "")
        guard let player = self.player else { return }
        RealmManager.shared.save(player)
        delegate?.animateOut()
    }
    
    @objc private func openWebView(_ sender: UIButton) {
        guard let url = URL(string: player?.meta?.profileurl ?? "") else { return }
        DispatchQueue.main.async {
            self.delegate?.presentWebView(url)
        }
        delegate?.animateOut()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func configure(_ player: Steam.DataClass.Player) {
        self.player = player
        usernameLabel.text = player.username
        guard let url = URL(string: player.avatar ?? "") else { return }
        self.avatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.avatarImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func setupConstraints() {
        self.addSubview(mainView)
        mainView.addSubview(avatarImageView)
        mainView.addSubview(usernameLabel)
        mainView.addSubview(closedButton)
        mainView.addSubview(addToFavouritesButton)
        mainView.addSubview(openWebViewButton)
        mainView.addSubview(commentTextField)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            commentTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            commentTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            commentTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
            
            addToFavouritesButton.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 12),
            addToFavouritesButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            addToFavouritesButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            addToFavouritesButton.heightAnchor.constraint(equalToConstant: 40),
            
            openWebViewButton.topAnchor.constraint(equalTo: addToFavouritesButton.bottomAnchor, constant: 12),
            openWebViewButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            openWebViewButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            openWebViewButton.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            usernameLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            closedButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            closedButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            closedButton.widthAnchor.constraint(equalToConstant: 30),
            closedButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
