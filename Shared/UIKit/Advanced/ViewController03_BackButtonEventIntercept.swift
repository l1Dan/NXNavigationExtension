//
//  ViewController03_BackButtonEventIntercept.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit
import NXNavigationExtension

class ViewController03_BackButtonEventIntercept: BaseTableViewController {
    
    private static let heightForFooterInSection = CGFloat(60.0)
    private static let reuseIdentifier = String(describing: UITableViewCell.self)
    
    private lazy var items = NavigationBackEvent.items
    
    private lazy var footerView: UIView = {
        let height = ViewController03_BackButtonEventIntercept.heightForFooterInSection
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        
        let button = UIButton()
        button.layer.borderColor = UIColor.purple.cgColor;
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("调用 “nx_pop” 方法返回", for: .normal)
        button.setTitleColor(.randomLight, for: .normal)
        button.addTarget(self, action: #selector(clickPopViewControllerButton(_:)), for: .touchUpInside)
        footerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            button.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.8),
            button.heightAnchor.constraint(equalTo: footerView.heightAnchor, multiplier: 0.8),
        ])

        return footerView

    }()
    
    private var selectedItemType = NavigationBackEvent.State.all
    
    @objc private func clickPopViewControllerButton(_ button: UIButton) {
        navigationController?.nx_popViewController(animated: true)
    }
    
    private func showAlertController(in viewController: UIViewController) {
        let alertController = UIAlertController(title: "提示", message: "是否继续返回？", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { [weak self] action in
            self?.navigationController?.popToViewController(viewController, animated: true)
        }))
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController03_BackButtonEventIntercept.reuseIdentifier)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = ViewController03_BackButtonEventIntercept.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isSelected ? .checkmark : .none
        
        if item.isSelected {
            selectedItemType = item.state
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for item in items {
            item.isSelected = false
        }
        items[indexPath.row].isSelected = true
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ViewController03_BackButtonEventIntercept.heightForFooterInSection
    }

}

extension ViewController03_BackButtonEventIntercept: NXNavigationInteractable {
    
    override var nx_shadowImageTintColor: UIColor? {
        return UIColor.customColor {
            return .lightGray
        } darkModeColor: {
            return .lightGray.withAlphaComponent(0.69)
        }
    }
    
    override var nx_useSystemBackButton: Bool {
        return true
    }
    
    func nx_navigationController(_ navigationController: UINavigationController, willPop viewController: UIViewController, interactiveType: NXNavigationInteractiveType) -> Bool {
        print("interactiveType: \(interactiveType), viewController: \(viewController)")
        
        if selectedItemType == .backButtonAction && interactiveType == .backButtonAction ||
            selectedItemType == .backButtonMenuAction && interactiveType == .backButtonMenuAction ||
            selectedItemType == .popGestureRecognizer && interactiveType == .popGestureRecognizer ||
            selectedItemType == .callNXPopMethod && interactiveType == .callNXPopMethod ||
            selectedItemType == .all {
            showAlertController(in: viewController)
            return false
        }
        
        return true
    }

}

