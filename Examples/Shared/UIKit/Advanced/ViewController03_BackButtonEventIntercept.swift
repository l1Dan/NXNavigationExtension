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
        
        let color = UIColor.customColor { .black } darkModeColor: { .white }
        let button = UIButton()
        button.layer.borderColor = color.cgColor;
        button.setTitleColor(color, for: .normal)
        
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("popWithCallNXPopMethod", comment: ""), for: .normal)
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
        let alertController = UIAlertController(title: NSLocalizedString("tips", comment: ""), message: NSLocalizedString("message", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .destructive, handler: { [weak self] action in
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
        cell.textLabel?.text = NSLocalizedString(item.title, comment: "")
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

extension ViewController03_BackButtonEventIntercept {
    
    override var nx_shadowColor: UIColor? {
        return UIColor.customColor { .lightGray } darkModeColor: { .lightGray.withAlphaComponent(0.69) }
    }
    
    override var nx_useSystemBackButton: Bool {
        return true
    }
}

extension ViewController03_BackButtonEventIntercept {
    func nx_navigationTransition(_ transitionViewController: UIViewController, navigationBackAction action: NXNavigationBackAction) -> Bool {
        print("navigationBackAction: \(action), viewController: \(transitionViewController)")
        
        if selectedItemType == .clickBackButton && action == .clickBackButton ||
            selectedItemType == .clickBackButtonMenu && action == .clickBackButtonMenu ||
            selectedItemType == .interactionGesture && action == .interactionGesture ||
            selectedItemType == .callingNXPopMethod && action == .callingNXPopMethod ||
            selectedItemType == .all {
            showAlertController(in: transitionViewController)
            return false
        }
        
        return true
    }
}

