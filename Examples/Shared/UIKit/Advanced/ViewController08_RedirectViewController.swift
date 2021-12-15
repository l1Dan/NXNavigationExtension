//
//  ViewController08_RedirectViewController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController08_RedirectViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private static let reuseIdentifier = String(describing: UITableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController08_RedirectViewController.reuseIdentifier)
        return tableView
    }()
    
    private lazy var items: [NavigationRedirect] = NavigationRedirect.items
    
    private func setJumpViewControllerCellClickEnabled(_ enabled: Bool) {
        for item in items {
            item.isSelectEnable = item.style == .jump ? true : enabled
        }
        tableView.reloadData()
    }
    
    private func showChooseJumpViewController() {
        HierarchyViewController.show(from: self, viewControllers: navigationController?.viewControllers) { [weak self] selectedViewController in
            guard let selectedViewController = selectedViewController, selectedViewController.isKind(of: UIViewController.self) else { return }
            // 设置 Cell 不能点击
            self?.setJumpViewControllerCellClickEnabled(false)
            self?.navigationController?.nx_redirectViewControllerClass(type(of: selectedViewController), initializeStandbyViewControllerUsing: {
                let vc = type(of: selectedViewController).init()
                vc.hidesBottomBarWhenPushed = true
                return vc
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if NSStringFromClass(type(of: self)) != NSStringFromClass(ViewController08_RedirectViewController.self) {
            navigationItem.title = NSStringFromClass(type(of: self)).removeModuleName
        }
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = ViewController08_RedirectViewController.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        
        let item = items[indexPath.row]
        cell.selectEnabled(item.isSelectEnable)
        cell.backgroundColor = nil
        
        if item.style == .choose {
            cell.textLabel?.text = item.title
            cell.accessoryType = .none
        } else if (item.style == .jump) {
            if let viewControllers = navigationController?.viewControllers {
                if viewControllers.count < 2 {
                    cell.textLabel?.text = item.title
                } else {
                    let redirectToViewController = viewControllers[viewControllers.count - 2]
                    if let redirectToViewController = redirectToViewController as? BaseViewController {
                        cell.backgroundColor = redirectToViewController.randomColor
                    } else {
                        cell.backgroundColor = nil
                    }
                    let title = redirectToViewController.navigationItem.title ?? NSStringFromClass(type(of: redirectToViewController))
                    cell.textLabel?.text = "\(item.title)\(title.removeModuleName)"
                }
            }
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "\(NSLocalizedString("pushTo", comment: ""))\(item.title.removeModuleName)"
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        if item.style == .choose {
            showChooseJumpViewController()
        } else if (item.style == .jump) {
            setJumpViewControllerCellClickEnabled(true)
            // 如果 selectedViewController ！= nil 就会跳转到对应的视图控制器，反之则返回上一个控制器
            navigationController?.popViewController(animated: true)
        } else {
            guard let Class = NSClassFromString(item.title) as? UIViewController.Type else { return }
            navigationController?.pushViewController(Class.init(), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return NSLocalizedString("redirectMessage", comment: "")
    }

}

extension ViewController08_RedirectViewController {
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return randomColor
    }
    
    override var nx_barTintColor: UIColor? {
        return .white
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: nx_barTintColor ?? .white]
    }
    
    override var nx_useSystemBackButton: Bool {
        return true
    }
    
}


// MARK: - An other

class ViewController01_Test: ViewController08_RedirectViewController {
    
}

class ViewController02_Test: ViewController08_RedirectViewController {
    
}

class ViewController03_Test: ViewController08_RedirectViewController {
    
}

class ViewController04_Test: ViewController08_RedirectViewController {
    
}

class ViewController05_Test: ViewController08_RedirectViewController {
    
}

fileprivate extension UITableViewCell {
    
    func selectEnabled(_ enabled: Bool) {
        isUserInteractionEnabled = enabled
        alpha = enabled ? 1.0 : 0.5
        for view in subviews {
            view.isUserInteractionEnabled = enabled
            view.alpha = enabled ? 1.0 : 0.5
        }
    }
    
}
