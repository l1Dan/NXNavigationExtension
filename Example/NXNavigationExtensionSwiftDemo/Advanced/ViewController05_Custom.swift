//
//  ViewController05_Custom.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController05_Custom: BaseTableViewController {
    
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
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.customDynamic(lightMode: { UIColor.white.withAlphaComponent(0.5) }, darkMode: { UIColor.white.withAlphaComponent(0.25) })
        button.setImage(UIImage(named: "NavigationBarBack"), for: .normal)
        button.addTarget(self.navigationController, action: #selector(navigationController?.nx_triggerSystemBackButtonHandler), for: .touchUpInside)
        return button
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.customDynamic(lightMode: { UIColor.white.withAlphaComponent(0.5) }, darkMode: { UIColor.white.withAlphaComponent(0.25) })
        button.setImage(UIImage(named: "NavigationBarAdd"), for: .normal)
        button.addTarget(self, action: #selector(clickAddButton(_:)), for: .touchUpInside)
        return button
    }()

    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nil;
        tableView.keyboardDismissMode = .onDrag
        
        nx_navigationBar.addContainerViewSubview(searchBar)
        nx_navigationBar.addContainerViewSubview(backButton)
        nx_navigationBar.addContainerViewSubview(addButton)
        
        let containerView = nx_navigationBar.containerView
        backButton.isHidden = !UIDevice.isPhone
        leftConstraint = backButton.leftAnchor.constraint(equalTo: containerView.leftAnchor)
        leftConstraint?.isActive = true
        
        backButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor).isActive = true
        backButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: UIDevice.isPhone ? 44.0 : 0.0).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2.0).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2.0).isActive = true
        searchBar.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 8.0).isActive = true
        searchBar.rightAnchor.constraint(equalTo: addButton.leftAnchor, constant: -8.0).isActive = true
        
        rightConstraint = addButton.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        rightConstraint?.isActive = true
        
        addButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let safeAreaInsets = navigationController?.navigationBar.safeAreaInsets else { return }
        leftConstraint?.constant = safeAreaInsets.left
        rightConstraint?.constant = -safeAreaInsets.right
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var nx_barTintColor: UIColor? {
        return .clear
    }
    
    override var nx_navigationBarBackgroundImage: UIImage? {
        return UIImage.navigationBarBackgorund
    }
    
    // 点击导航栏控件事件可以由 ContainerView 响应
    override var nx_containerViewWithoutNavigtionBar: Bool {
        return true
    }
    
}

@objc
extension ViewController05_Custom {
    private func clickAddButton(_ button: UIButton) {
        guard let navigationController = navigationController else { return }
        let controller = type(of: navigationController).init(rootViewController: ViewController12_Modal())
        present(controller, animated: true, completion: nil)
    }
}

