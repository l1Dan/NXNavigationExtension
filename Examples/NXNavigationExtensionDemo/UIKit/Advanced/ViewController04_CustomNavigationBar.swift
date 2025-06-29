//
//  ViewController04_CustomNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import NXNavigationExtension
import UIKit

class ViewController04_CustomNavigationBar: CustomTableViewController {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .systemGray
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var backButton: UIButton = {
        let isRightToLeft = navigationController?.navigationBar.semanticContentAttribute ?? .forceLeftToRight == .forceRightToLeft
        let image = isRightToLeft ? UIImage(systemName: "arrow.left")?.imageFlippedForRightToLeftLayoutDirection() : UIImage(systemName: "arrow.left")
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 8.0
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(clickBackButton(_:)), for: .touchUpInside)
        backButton.backgroundColor = UIColor.customColor { .white.withAlphaComponent(0.5) } darkModeColor: { .white.withAlphaComponent(0.25) }
        return backButton
    }()

    private lazy var addButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 8.0
        backButton.setImage(UIImage(systemName: "plus"), for: .normal)
        backButton.addTarget(self, action: #selector(clickAddButton(_:)), for: .touchUpInside)
        backButton.backgroundColor = UIColor.customColor { .white.withAlphaComponent(0.5) } darkModeColor: { .white.withAlphaComponent(0.25) }
        return backButton
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.randomLight.cgColor, UIColor.randomDark.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0)
        return gradientLayer
    }()

    @objc
    private func clickBackButton(_ button: UIButton) {
        navigationController?.nx_popViewController(animated: true)
    }

    @objc
    private func clickAddButton(_ button: UIButton) {
        guard let navigationController else { return }
        let newNavigationController = type(of: navigationController).init(rootViewController: ViewController10_Present())
        present(newNavigationController, animated: true, completion: nil)
    }

    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nil
        tableView.keyboardDismissMode = .onDrag

        guard let nx_navigationBar else { return }
        nx_navigationBar.contentView.addSubview(searchBar)
        nx_navigationBar.contentView.addSubview(backButton)
        nx_navigationBar.contentView.addSubview(addButton)
        nx_navigationBar.layer.insertSublayer(gradientLayer, below: nx_navigationBar.layer.sublayers?.first)

        let contentView = nx_navigationBar.contentView
        backButton.isHidden = !UIDevice.isPhoneDevice

        leftConstraint = backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        leftConstraint?.isActive = true
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor),
            backButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: UIDevice.isPhoneDevice ? 44.0 : 0)
        ])

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.0),
            searchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.0),
            searchBar.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8.0),
            searchBar.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8.0)
        ])

        rightConstraint = addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        rightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor),
            addButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 44.0)
        ])
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let safeAreaInsets = navigationController?.navigationBar.safeAreaInsets else { return }
        leftConstraint?.constant = safeAreaInsets.left
        rightConstraint?.constant = safeAreaInsets.right
        gradientLayer.frame = nx_navigationBar?.bounds ?? .zero
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController04_CustomNavigationBar {
    override var nx_barTintColor: UIColor? {
        return .clear
    }

    override var nx_systemNavigationBarUserInteractionDisabled: Bool {
        return true
    }
}
