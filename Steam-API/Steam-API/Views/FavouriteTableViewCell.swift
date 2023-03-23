//
//  FavouriteTableViewCell.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import UIKit
import SDWebImage

class FavouriteTableViewCell: UICollectionViewCell {
    
    static var identifier = "FavouriteTableViewCell"
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .systemIndigo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addBlur(.systemThinMaterialDark)
        return view
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(_ player: PlayerObject) {
        usernameLabel.text = player.username
        commentLabel.text = player.comment ?? ""
        guard let url = URL(string: player.avatar ?? "") else { return }
        self.avatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.avatarImageView.sd_setImage(with: url, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(mainView)
        mainView.addSubview(avatarImageView)
        mainView.addSubview(usernameLabel)
        mainView.addSubview(commentLabel)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
        
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            usernameLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            commentLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            commentLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            commentLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            commentLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -20)
        ])
    }

}
