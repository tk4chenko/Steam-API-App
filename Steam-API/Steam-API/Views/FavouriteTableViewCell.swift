//
//  FavouriteTableViewCell.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import UIKit
import SDWebImage

final class FavouriteTableViewCell: UITableViewCell {
    
    static let identifier = "FavouriteTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .systemIndigo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .tintColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .tintColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func configureCell(_ player: PlayerObject) {
        usernameLabel.text = player.username
        if player.comment?.count == 0 {
            commentLabel.text = "No message."
        } else {
            commentLabel.text = player.comment
        }
        guard let url = URL(string: player.avatar ?? "") else { return }
        self.avatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.avatarImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func setupConstraints() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(commentLabel)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
        
            usernameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            commentLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            commentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            commentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
