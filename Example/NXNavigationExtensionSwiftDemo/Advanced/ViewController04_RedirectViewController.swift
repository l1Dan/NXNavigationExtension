//
//  ViewController04_RedirectViewController.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController04_RedirectViewController: BaseViewController {
    
    private static let reuseIdentifier = String(describing: UITableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController04_RedirectViewController.reuseIdentifier)
        return tableView
    }()
    
    private lazy var items: [RedirectControllerItem] = {
        return [
            RedirectControllerItem(title: String(describing: ViewController01_Test.self), itemType: .test1),
            RedirectControllerItem(title: String(describing: ViewController02_Test.self), itemType: .test2),
            RedirectControllerItem(title: String(describing: ViewController03_Test.self), itemType: .test3),
            RedirectControllerItem(title: String(describing: ViewController04_Test.self), itemType: .test4),
            RedirectControllerItem(title: String(describing: ViewController05_Test.self), itemType: .test5),
            RedirectControllerItem(title: String(describing: "选择需要跳转的控制器类型"), itemType: .choose),
            RedirectControllerItem(title: String(describing: "⭐️重定向到："), itemType: .jump),
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if String(describing: self) != String(describing: ViewController04_RedirectViewController.self) {
            self.navigationItem.title = String(describing: type(of: self)).toClassName
        }

        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return randomColor
    }
    
    override var nx_barTintColor: UIColor? {
        return .white
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
}

extension ViewController04_RedirectViewController {
    
    private func jumpViewControllerCellClick(enabled: Bool) {
        for item in items {
            if item.itemType == .jump {
                item.isClickEnabled = true
            } else {
                item.isClickEnabled = enabled
            }
        }
        tableView.reloadData()
    }
    
    private func showChooseJumpViewController() {
        HierarchyViewController.showFromViewController(self, withViewControllers: self.navigationController?.viewControllers) { selectedViewController in
            guard let selectedViewController = selectedViewController else { return }
            self.jumpViewControllerCellClick(enabled: false)
            self.navigationController?.nx_redirectViewControllerClass(type(of: selectedViewController), initializeStandbyViewControllerBlock: { () -> UIViewController in
                let vc = type(of: selectedViewController.self).init()
                vc.hidesBottomBarWhenPushed = true
                return vc
            })
        }
    }
    
}

extension ViewController04_RedirectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = ViewController04_RedirectViewController.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        
        let item = items[indexPath.row]
        cell.setCellClick(enabled: item.isClickEnabled)
        cell.backgroundColor = nil
        cell.textLabel?.textColor = .customText
        
        if item.itemType == .choose {
            cell.textLabel?.text = item.title
            cell.accessoryType = .none
        } else if item.itemType == .jump {
            if let viewControllers = navigationController?.viewControllers, viewControllers.count < 2 {
                cell.textLabel?.text = item.title
            } else if let viewControllers = navigationController?.viewControllers {
                let redirectToViewController = viewControllers[viewControllers.count - 2]
                if let redirectToViewController = redirectToViewController as? BaseViewController {
                    cell.backgroundColor = redirectToViewController.randomColor
                } else {
                    cell.backgroundColor = nil
                }
                cell.textLabel?.text = item.title + String(describing: type(of: redirectToViewController))
            }
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "点击跳转: \(item.title)"
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        if item.itemType == .choose {
            showChooseJumpViewController()
        } else if (item.itemType == .jump) {
            jumpViewControllerCellClick(enabled: true)
            
            // 如果 selectedViewController ！= nil 就会跳转到对应的视图控制器，反之则返回上一个控制器
            navigationController?.popViewController(animated: true)
        } else {
            let viewController = (item.title.toAnyClass as! ViewController04_RedirectViewController.Type).init()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "功能💉:\n1.自定义跳转到指定控制器类型。\n2.如果跳转的控制器类型不存在则会创建一个新的控制器对象。\n3.目标控制器类型选择好之后可以点击“返回按钮返回”、“手势返回”和点击“⭐️重定向到”，这 3 种方式都可以回到选择类型的所对应的查找到的第一个视图控制器的实例中。\n\n注意⚠️:\n1.控制器类型的查找规则是从栈（ViewControllers）前面往后面查找的，只会判断是否为同一个“类”，而非同一个“实例对象”。查找到则返回对应的“类”，查找不到则创建一个“新的控制器对象实例”。\n2.在不同的导航栏控制器之间不能跳转，只有在同一个导航栏控制器中跳转功能才会生效。"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }

}

class ViewController01_Test: ViewController04_RedirectViewController { }

class ViewController02_Test: ViewController04_RedirectViewController { }

class ViewController03_Test: ViewController04_RedirectViewController { }

class ViewController04_Test: ViewController04_RedirectViewController { }

class ViewController05_Test: ViewController04_RedirectViewController { }
