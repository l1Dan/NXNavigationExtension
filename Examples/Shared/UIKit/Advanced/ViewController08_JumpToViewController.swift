//
//  ViewController08_JumpToViewController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

private var popAndPush = "Pop&Push"
private var popAndPresent = "Pop&Present"
private var currentTransitionButtonTitle = popAndPush
private var isAnimated = true

extension Notification.Name {
    static let didChangeTransitionButtonTitle = Notification.Name("TransitionViewControllerDidChangeTransitionButtonTitle")
}

class ViewController08_JumpToViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private static let reuseIdentifier = String(describing: UITableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController08_JumpToViewController.reuseIdentifier)
        return tableView
    }()
    
    private lazy var items: [NavigationJump] = NavigationJump.items
    
    private func setJumpViewControllerCellClickEnabled(_ enabled: Bool) {
        for item in items {
            item.isSelectEnable = item.style == .jump ? true : enabled
        }
        tableView.reloadData()
    }
    
    private func showChooseJumpViewController() {
        guard var viewControllers = navigationController?.viewControllers else { return }
        viewControllers.removeLast() // 排除当前已经在显示的
        
        HierarchyViewController.show(from: self, viewControllers: viewControllers) { [weak self] selectedViewController in
            guard let selectedViewController = selectedViewController, selectedViewController.isKind(of: UIViewController.self) else { return }
            // 设置 Cell 不能点击
            self?.setJumpViewControllerCellClickEnabled(false)
            self?.navigationController?.nx_removeViewControllers(until: type(of: selectedViewController), insertsToBelowWhenNotFoundUsing: {
                let vc = type(of: selectedViewController).init()
                vc.hidesBottomBarWhenPushed = true
                return vc
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRightBarButtonItem()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeTransitionButtonTitleNotification(_:)), name: .didChangeTransitionButtonTitle, object: nil)
        
        if NSStringFromClass(type(of: self)) != NSStringFromClass(ViewController08_JumpToViewController.self) {
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didChangeTransitionButtonTitle, object: nil)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = ViewController08_JumpToViewController.reuseIdentifier
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
                    let jumpToViewController = viewControllers[viewControllers.count - 2]
                    if let jumpToViewController = jumpToViewController as? BaseViewController {
                        cell.backgroundColor = jumpToViewController.randomColor
                    } else {
                        cell.backgroundColor = nil
                    }
                    let title = jumpToViewController.navigationItem.title ?? NSStringFromClass(type(of: jumpToViewController))
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
        return NSLocalizedString("jumpMessage", comment: "")
    }

}

extension ViewController08_JumpToViewController {
    private func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: currentTransitionButtonTitle, style: .plain, target: self, action: #selector(clickRightBarButtonItem(_:)))
    }
    
    @objc private func clickRightBarButtonItem(_ sender: UIBarButtonItem) {
        let vc = ViewController_Transition()
        vc.hidesBottomBarWhenPushed = true
        if currentTransitionButtonTitle == popAndPush {
            navigationController?.nx_popViewControllerWithPush(vc, animated: isAnimated)
        } else {
            navigationController?.nx_popViewControllerWithPresent(vc, animated: isAnimated)
        }
    }
    
    @objc private func didChangeTransitionButtonTitleNotification(_ note: Notification) {
        setupRightBarButtonItem()
    }
}

extension ViewController08_JumpToViewController {
    
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

class ViewController_Transition: BaseViewController {
    
    var disappearCallback: (() -> Void)?
    
    private lazy var chooseTransitionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(currentTransitionButtonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickChooseButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var toggleView: UIView = {
        let label = UILabel()
        label.text = "Use animated: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.sizeToFit()
        
        let switchButton = UISwitch()
        switchButton.isOn = isAnimated
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.addTarget(self, action: #selector(clickToggleButton(_:)), for: .valueChanged)
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        [label, switchButton].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            switchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            switchButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0),
            switchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [toggleView, chooseTransitionButton].forEach(view.addSubview)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                toggleView.heightAnchor.constraint(equalToConstant: 60),
                toggleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
                toggleView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            ])
        } else {
            NSLayoutConstraint.activate([
                toggleView.heightAnchor.constraint(equalToConstant: 60),
                toggleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                toggleView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            ])
        }
        
        NSLayoutConstraint.activate([
            chooseTransitionButton.topAnchor.constraint(equalTo: toggleView.bottomAnchor, constant: 8),
            chooseTransitionButton.centerXAnchor.constraint(equalTo: toggleView.centerXAnchor, constant: 0)
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disappearCallback?()
    }
    
    @objc private func clickToggleButton(_ sender: UISwitch) {
        isAnimated = sender.isOn
    }
    
    @objc private func clickChooseButton(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        
        currentTransitionButtonTitle = title == popAndPresent ? popAndPush : popAndPresent
        sender.setTitle(currentTransitionButtonTitle, for: .normal)
        NotificationCenter.default.post(name: .didChangeTransitionButtonTitle, object: nil)
    }
    
}

class VC01_Test: ViewController08_JumpToViewController {
    
}

class VC02_Test: ViewController08_JumpToViewController {
    
}

class VC03_Test: ViewController08_JumpToViewController {
    
}

class VC04_Test: ViewController08_JumpToViewController {
    
}

class VC05_Test: ViewController08_JumpToViewController {
    
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
