//
//  ViewController04_CustomNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController04_CustomNavigationBar: CustomTableViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .systemGray
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "请输入关键字"
        return searchBar
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 8.0
        backButton.setImage(UIImage(named: "NavigationBarBack"), for: .normal)
        backButton.addTarget(self, action: #selector(clickBackButton(_:)), for: .touchUpInside)
        backButton.backgroundColor = UIColor.customColor(lightModeColor: {
            return .white.withAlphaComponent(0.5)
        }, darkModeColor: {
            return .white.withAlphaComponent(0.25)
        })
        return backButton
    }()
    
    private lazy var addButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 8.0
        backButton.setImage(UIImage(named: "NavigationBarAdd"), for: .normal)
        backButton.addTarget(self, action: #selector(clickAddButton(_:)), for: .touchUpInside)
        backButton.backgroundColor = UIColor.customColor(lightModeColor: {
            return .white.withAlphaComponent(0.5)
        }, darkModeColor: {
            return .white.withAlphaComponent(0.25)
        })
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
        guard let navigationController = navigationController else { return }
        let newNavigationController = type(of: navigationController).init(rootViewController: ViewController10_Present())
        present(newNavigationController, animated: true, completion: nil)
    }
    
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = nil
        tableView.keyboardDismissMode = .onDrag
        
        guard let nx_navigationBar = nx_navigationBar else { return }
        nx_navigationBar.contentView.addSubview(searchBar)
        nx_navigationBar.contentView.addSubview(backButton)
        nx_navigationBar.contentView.addSubview(addButton)
        nx_navigationBar.layer.addSublayer(gradientLayer)

        let contentView = nx_navigationBar.contentView
        backButton.isHidden = !UIDevice.isPhoneDevice
        
        leftConstraint = backButton.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        leftConstraint?.isActive = true
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor),
            backButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: UIDevice.isPhoneDevice ? 44.0 : 0),
        ])
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.0),
            searchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.0),
            searchBar.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 8.0),
            searchBar.rightAnchor.constraint(equalTo: addButton.leftAnchor, constant: -8.0),
        ])
        
        rightConstraint = addButton.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        rightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor),
            addButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 44.0),
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var safeAreaInsets = navigationController?.navigationBar.layoutMargins
        if #available(iOS 11.0, *) {
            safeAreaInsets = navigationController?.navigationBar.safeAreaInsets
        }
        
        guard let safeAreaInsets = safeAreaInsets else { return }
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
    
    /// 点击导航栏控件事件可以由 contentView 响应
    override var nx_contentViewWithoutNavigationBar: Bool {
        return true
    }
    
}
