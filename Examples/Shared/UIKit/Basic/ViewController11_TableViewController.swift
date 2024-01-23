//
//  ViewController11_TableViewController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController11_TableViewController: BaseTableViewController {

    private static let reuseIdentifier = String(describing: UITableViewCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:ViewController11_TableViewController.reuseIdentifier)
        
        guard navigationItem.leftBarButtonItem == nil else { return }
        let item = UIBarButtonItem(image: UIImage(named: "NavigationBarClose"), style: .plain, target: self, action: #selector(clickCloseDrawerButtonItem(_:)))
        item.tintColor = UIColor.customColor(lightModeColor: {
            return .black
        }, darkModeColor: {
            return .white
        })
        navigationItem.rightBarButtonItem = item
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = ViewController11_TableViewController.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier:reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = String(format: "Row: %02zd", indexPath.row + 1)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.customColor { .randomLight } darkModeColor: { .randomDark }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(ViewController07_UpdateNavigationBar(), animated: true)
    }
    
    @objc
    private func clickCloseDrawerButtonItem(_ item: UIBarButtonItem?) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController11_TableViewController {
    
    override var nx_shadowColor: UIColor? {
        return UIColor.customColor { .lightGray } darkModeColor: { .lightGray.withAlphaComponent(0.65) }
    }
    
}

extension ViewController11_TableViewController: SlidingInteractiveNavigation {
    var swipeDirectionAction: SlidingSwipeDirectionAction {
        return .right { [weak self] in
            self?.clickCloseDrawerButtonItem(nil)
        }
    }
}
