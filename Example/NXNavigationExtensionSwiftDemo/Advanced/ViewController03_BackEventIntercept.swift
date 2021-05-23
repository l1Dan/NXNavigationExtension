//
//  ViewController03_BackEventIntercept.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit
import NXNavigationExtension

class ViewController03_BackEventIntercept: UITableViewController {
    
    private static let reuseIdentifier = String(describing: UITableViewCell.self)
    
    private lazy var items: [EventInterceptItem] = EventInterceptItem.makeAllItems()
    
    private var currentItemType = EventInterceptItem.ItemType.both

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController03_BackEventIntercept.reuseIdentifier)
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return UIColor.customDynamic(lightMode: { UIColor.lightGray }, darkMode: { UIColor.lightGray.withAlphaComponent(0.5) })
    }

}

extension ViewController03_BackEventIntercept {
    
    private func showAlertController() {
        let alertController = UIAlertController(title: "提示", message: "是否继续返回？", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - Table view data source

extension ViewController03_BackEventIntercept {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = ViewController03_BackEventIntercept.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.itemType.rawValue
        cell.accessoryType = item.isSelected ? .checkmark : .none
        
        if #available(iOS 13.0, *) {
            cell.backgroundColor = .secondarySystemGroupedBackground
        } else {
            cell.backgroundColor = UIColor.customGroupedBackground
        }
        
        if item.isSelected { currentItemType = item.itemType }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        for item in items { item.isSelected = false }
        items[indexPath.row].isSelected = true
        tableView.reloadData()
    }
    
}

extension ViewController03_BackEventIntercept: NXNavigationExtensionInteractable {
    func navigationController(_ navigationController: UINavigationController, willPopViewControllerUsingInteractingGesture interactingGesture: Bool) -> Bool {
        if currentItemType == .both {
            showAlertController()
            return false
        }
        
        if currentItemType == .backButton {
            if !interactingGesture {
                showAlertController()
                return false
            }
        }
        
        if currentItemType == .popGesture {
            if interactingGesture {
                showAlertController()
                return false
            }
        }
        
        return true
    }
}
