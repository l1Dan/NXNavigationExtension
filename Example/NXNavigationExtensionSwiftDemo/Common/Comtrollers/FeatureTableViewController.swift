//
//  FeatureTableViewController.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class FeatureTableViewController: UITableViewController {
    
    private static let reuseIdentifier = "FeatureTableViewCellIdentifer"
    
    private lazy var sections: [TableViewSection] = TableViewSection.makeAllSections()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: FeatureTableViewController.reuseIdentifier)
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.customTitle]
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return UIColor.customDynamic { UIColor.lightGray } darkMode: { UIColor.lightGray.withAlphaComponent(0.65) }
    }
    
    override var nx_useSystemBlurNavigationBar: Bool {
        return true
    }
    
}

extension FeatureTableViewController {
    
    private func viewControllerFor(itemType: TableViewSectionItem.ItemType) -> UIViewController {
        switch itemType {
        // Basic
        case .navigationBarBackgroundColor: return ViewController01_BackgroundColor()
        case .navigationBarBackgroundImage: return ViewController02_BackgroundImage()
        case .navigationBarTransparent: return ViewController03_Transparent()
        case .navigationBarTranslucent: return ViewController04_Translucent()
        case .navigationBarShadowColor: return ViewController05_ShadowColor()
        case .navigationBarShadowImage: return ViewController06_ShadowImage()
        case .navigationBarCustomBackButtonImage: return ViewController07_CustomBackButtonImage()
        case .navigationBarCustomBackButton: return ViewController08_CustomBackButton()
        case .navigationBarFullScreen: return ViewController09_FullScreen()
        case .navigationBarScrollView: return ViewController10_ScrollView()
        case .navigationBarScrollViewWithFullScreen: return ViewController11_ScrollViewWithFullScreen()
        case .navigationBarModal: return ViewController12_Modal()
        case .navigationBarBlur: return ViewController13_Blur()
        // Advanced
        case .navigationBarDisablePopGesture: return ViewController01_DisablePopGesture()
        case .navigationBarFullPopGesture: return ViewController02_FullPopGesture()
        case .navigationBarBackEventIntercept: return ViewController03_BackEventIntercept()
        case .navigationBarRedirectViewController: return ViewController04_RedirectViewController()
        case .navigationBarCustom: return ViewController05_Custom()
        case .navigationBarClickEventHitToBack: return ViewController06_ClickEventHitToBack()
        case .navigationBarScrollChangeNavigationBar: return ViewController07_ScrollChangeNavigationBar()
        case .navigationBarWebView: return ViewController08_WebView()
        case .navigationBarUpdateNavigationBar: return RandomColorViewController()
        }
    }
    
}

// MARK: - Table view data source

extension FeatureTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = FeatureTableViewController.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.textColor = .customTitle
        cell.textLabel?.text = String(format: "%02zd: %@", indexPath.row + 1, item.itemType.rawValue)
        cell.accessoryType = item.showDisclosureIndicator ? .disclosureIndicator : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = sections[indexPath.section].items[indexPath.row]
        let viewController = viewControllerFor(itemType: item.itemType)
        viewController.title = item.itemType.rawValue
        
        guard let navigationController = navigationController else { return }
        let controller = type(of: navigationController).init(rootViewController: viewController)
        if viewController.isMember(of: ViewController12_Modal.self) {
            present(controller, animated: true, completion: nil)
        } else {
            if UIDevice.isPhone {
                viewController.hidesBottomBarWhenPushed = true
                navigationController.pushViewController(viewController, animated: true)
            } else {
                guard let detailNavigationController = splitViewController?.viewControllers.last as? UINavigationController,
                      let detailViewController = detailNavigationController.viewControllers.last else { return }
                if !detailViewController.isMember(of: type(of: viewController)) {
                    showDetailViewController(controller, sender: nil)
                }
            }
        }
    }
}

