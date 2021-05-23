//
//  ViewController10_ScrollView.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController10_ScrollView: UITableViewController {
    
    private static let reuseIdentifier = String(describing: UITableViewCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController10_ScrollView.reuseIdentifier)
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return UIColor.customDynamic(lightMode: { UIColor.lightGray }, darkMode: { UIColor.lightGray.withAlphaComponent(0.65) })
    }
    
}

// MARK: - Table view data source

extension ViewController10_ScrollView {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = ViewController10_ScrollView.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = String(format: "Row: %02zd with UIScrollView", indexPath.row + 1)
        cell.textLabel?.textColor = .customText
        cell.backgroundColor = UIColor.customDynamic(lightMode: { .randomLight }, darkMode: { .randomDark })
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(RandomColorViewController(), animated: true)
    }

}
