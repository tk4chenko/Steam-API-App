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

final class PopUpView: UIView {
    
    weak var delegate: PopViewDelegate?
    
    var isSuccessed = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var height: Int = 240
    var realmManager = RealmManager.shared
    
    private var player: Steam.DataClass.Player?
    
    private lazy var usernameLabel = createUsernameLabel()
    private lazy var commentTextField = createCommentTextField()
    private lazy var mainView = createMainView()
    private lazy var closedButton = createClosedButton()
    private lazy var addToFavouritesButton = createAddToFavouritesButton()
    private lazy var openWebViewButton = createOpenWebViewButton()
    private lazy var avatarImageView = createAvatarImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commentTextField.delegate = self
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func addButtonsActions() {
        closedButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        addToFavouritesButton.addTarget(self, action: #selector(addToFavourites(_:)), for: .touchUpInside)
        openWebViewButton.addTarget(self, action: #selector(openWebView(_:)), for: .touchUpInside)
        addToFavouritesButton.setTitle("Add to favorites", for: .normal)
        addToFavouritesButton.setTitle("Remove from favorites", for: .selected)
    }
    
    private func checkIsFavorite() {
        for player in realmManager.favourites {
            if player.id == self.player?.id {
                addToFavouritesButton.isSelected = true
                return
            } else {
                addToFavouritesButton.isSelected = false
            }
        }
    }
    
    func configure(_ player: Steam.DataClass.Player?) {
        if let myPlayer = player {
            isSuccessed = true
            self.player = myPlayer
            guard let url = URL(string: myPlayer.avatar ?? "") else { return }
            usernameLabel.text = myPlayer.username
            self.avatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            self.avatarImageView.sd_setImage(with: url, completed: nil)
            checkIsFavorite()
            addButtonsActions()
        } else {
            isSuccessed = false
            usernameLabel.text = "There is no such player."
            commentTextField.isHidden = true
            openWebViewButton.isHidden = true
            addToFavouritesButton.isHidden = true
        }
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        delegate?.animateOut()
    }
    
    @objc private func addToFavourites(_ sender: UIButton) {
        guard var player = self.player else { return }
        player.comment = commentTextField.text
        switch sender.isSelected {
        case true:
            guard let realmPlayer = realmManager.realm.object(ofType: PlayerObject.self, forPrimaryKey: player.id) else { return }
            realmManager.delete(realmPlayer)
        case false:
            realmManager.save(player)
        }
        delegate?.animateOut()
    }
    
    @objc private func openWebView(_ sender: UIButton) {
        guard let url = URL(string: player?.meta?.profileurl ?? "") else { return }
        DispatchQueue.main.async {
            self.delegate?.presentWebView(url)
        }
        delegate?.animateOut()
    }
}

extension PopUpView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}

extension PopUpView {
    private func setupConstraints() {
        self.addSubview(mainView)
        mainView.addSubviews([avatarImageView, usernameLabel, closedButton, addToFavouritesButton, openWebViewButton, commentTextField])
        var heightConstant: CGFloat = 0
        if isSuccessed {
            heightConstant = 240
        } else {
            heightConstant = 80
        }
        let selfConstraints = [
            self.widthAnchor.constraint(equalToConstant: 300),
            self.heightAnchor.constraint(equalToConstant: heightConstant),
            self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor),
        ]
        let mainViewConstraints = [
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        let avatarImageViewConstraints = [
            avatarImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
        ]
        let commentTextFieldConstraints = [
            commentTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            commentTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            commentTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
        ]
        let addToFavouritesButtonConstraints = [
            addToFavouritesButton.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 12),
            addToFavouritesButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            addToFavouritesButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            addToFavouritesButton.heightAnchor.constraint(equalToConstant: 40),
        ]
        let openWebViewButtonConstraints = [
            openWebViewButton.topAnchor.constraint(equalTo: addToFavouritesButton.bottomAnchor, constant: 12),
            openWebViewButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            openWebViewButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            openWebViewButton.heightAnchor.constraint(equalToConstant: 40),
        ]
        let usernameLabelConstraints = [
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            usernameLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
        ]
        let closedButtonConstraints = [
            closedButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            closedButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            closedButton.widthAnchor.constraint(equalToConstant: 30),
            closedButton.heightAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(mainViewConstraints)
        NSLayoutConstraint.activate(avatarImageViewConstraints)
        NSLayoutConstraint.activate(commentTextFieldConstraints)
        NSLayoutConstraint.activate(addToFavouritesButtonConstraints)
        NSLayoutConstraint.activate(openWebViewButtonConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(closedButtonConstraints)
        NSLayoutConstraint.activate(selfConstraints)
    }
}
