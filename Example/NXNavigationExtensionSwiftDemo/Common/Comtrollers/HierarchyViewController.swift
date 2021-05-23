//
//  HierarchyViewController.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class HierarchyViewController: BaseViewController {
    
    private static let tableViewCellHeight = CGFloat(44.0)
    
    private static let reuseIdentifier = String(describing: UITableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: HierarchyViewController.reuseIdentifier)
        return tableView
    }()
    
    private var completionHandler: ((UIViewController?) -> ())?
    private var chooseViewControllers: [UIViewController]?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(tableView)
        
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        widthConstraint = tableView.widthAnchor.constraint(equalToConstant: 0.0);
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0.0);
        
        widthConstraint?.isActive = true
        heightConstraint?.isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let chooseViewControllers = chooseViewControllers else { return }
        
        let size = UIScreen.main.bounds.size
        let height = CGFloat(chooseViewControllers.count) * HierarchyViewController.tableViewCellHeight + 88.0
        let maxHeight = CGFloat.minimum(height, size.height - 150.0)
        let maxWidth = size.width * 0.8
            
        widthConstraint?.constant = maxWidth
        heightConstraint?.constant = maxHeight
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        dismiss(animated: false) { [weak self] in
            self?.completionHandler?(nil)
        }
    }
    
    deinit {
        print(#function)
    }
    
}

extension HierarchyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Note: + 1 添加一行用于 “创建一个新的 UIViewController” Item
        guard let count = chooseViewControllers?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = HierarchyViewController.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.backgroundColor = nil

        if let chooseViewControllers = chooseViewControllers, indexPath.row < chooseViewControllers.count {
            let viewController = chooseViewControllers[indexPath.row]
            cell.textLabel?.text = String(describing: type(of: viewController))
            cell.textLabel?.textColor = .customText

            if let vc = viewController as? BaseViewController {
                cell.backgroundColor = vc.randomColor
            }
        } else {
            cell.textLabel?.text = "创建新的 UIViewController 实例对象"
            cell.textLabel?.textColor = UIColor.customDynamic(lightMode: { UIColor.blue }, darkMode: { UIColor.blue.withAlphaComponent(0.5) })
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let chooseViewControllers = chooseViewControllers  else { return }
        var viewController: UIViewController?
        if indexPath.row < chooseViewControllers.count {
            viewController = chooseViewControllers[indexPath.row]
        } else {
            viewController = RandomColorViewController()
        }
        
        dismiss(animated: false) { [weak self] in
            self?.completionHandler?(viewController)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HierarchyViewController.tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "选择需要跳转的视图控制器类型"
    }
    
}

extension HierarchyViewController {
    
    static func showFromViewController(_ viewController: UIViewController, withViewControllers viewControllers: [UIViewController]?, completionHandler:((UIViewController?) -> ())?) {
        let vc = HierarchyViewController()
        vc.chooseViewControllers = viewControllers
        vc.completionHandler = completionHandler
        vc.modalPresentationStyle = .custom
        viewController.present(vc, animated: false, completion: nil)
    }
    
}
