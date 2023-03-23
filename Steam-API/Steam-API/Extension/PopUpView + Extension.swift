//
//  PopUpView + Extension.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 22.03.2023.
//

import UIKit

extension PopUpView {
    func createUsernameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }
    
    func createCommentTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter comment here"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }
    
    func createMainView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .lightGray
        view.addShadow()
        return view
    }
    
    func createClosedButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.tintColor = .blue
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }
    
    func createAddToFavouritesButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 8
        button.setTitle("Add to favorites", for: .normal)
        return button
    }
    
    func createOpenWebViewButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 8
        button.setTitle("Open web view", for: .normal)
        return button
    }
    
    func createAvatarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .systemIndigo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
