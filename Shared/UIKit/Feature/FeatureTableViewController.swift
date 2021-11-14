//
//  FeatureTableViewController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import UIKit

class FeatureTableViewController: BaseTableViewController {
    
    private static let reuseIdentifier = "FeatureTableViewCellIdentifer"
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.backgroundImage = UIImage() // Remove shadow
        
        if #available(iOS 13.0, *) {
            // Nothing...
        } else {
            searchController.searchBar.backgroundColor = .customDarkGray
            searchController.view.backgroundColor = .customDarkGray
        }
        return searchController
    }()
    
    private lazy var presentDrawerButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "NavigationBarMore"), style: .plain, target: self, action: #selector(clickOpenDraweButtonItem(_:)))
        item.tintColor = .white
        return item
    }()
    
    private lazy var animationTransitionDelegate: DrawAnimationTransitionDelegate = {
        let delegate = DrawAnimationTransitionDelegate()
        delegate.setupDrawer(with: self, inView: view)
        return delegate
    }()
    
    private lazy var sections = NavigationFeatureSection.sections(for: true)
    
    private func viewController(for itemType: NavigationFeatureItem.Style) -> UIViewController? {
        switch (itemType) {
            // Basic
        case .backgroundColor: return ViewController01_BackgroundColor()
        case .backgroundImage: return ViewController02_BackgroundImage()
        case .transparent: return ViewController03_Transparent()
        case .likeSystemNavigationBar: return ViewController04_LikeSystemNavigationBar()
        case .shadowColor: return ViewController05_ShadowColor()
        case .shadowImage: return ViewController06_ShadowImage()
        case .customBackImage: return ViewController07_CustomBackImage()
        case .customBackView: return ViewController08_CustomBackView()
        case .fullScreenColor: return ViewController09_FullScreenColor()
        case .present: return ViewController10_Present()
        case .tableViewController: return ViewController11_TableViewController()
        case .tableViewControllerWithFullScren: return ViewController12_TableViewControllerWithFullScreen()
        case .customBlurNavigationBar: return ViewController13_CustomBlurNavigationBar()
            // Advanced
        case .edgePopGestureDisable: return ViewController01_EdgePopGestureDisable()
        case .fullScreenPopGestureEnable: return ViewController02_FullScreenPopGestureEnable()
        case .backButtonEventIntercept: return ViewController03_BackButtonEventIntercept(style: .grouped)
        case .customNavigationBar: return ViewController04_CustomNavigationBar()
        case .navigationBarDisable: return ViewController05_NavigationBarDisable()
        case .webView: return ViewController06_WebView()
        case .updateNavigationBar: return ViewController07_UpdateNavigationBar()
        case .redirectViewController: return ViewController08_RedirectViewController()
        case .scrollChangeNavigationBar: return ViewController09_ScrollChangeNavigationBar()
        case .customViewControllerTransitionAnimation:
            animationTransitionDelegate.openDrawer()
            return nil
        default: return nil
        }
    }
    
    @objc
    private func clickOpenDraweButtonItem(_ item: UIBarButtonItem) {
        animationTransitionDelegate.openDrawer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = presentDrawerButtonItem
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: FeatureTableViewController.reuseIdentifier)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = FeatureTableViewController.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: restorationIdentifier)
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = String(format: "%02zd: %@", indexPath.row + 1, NSLocalizedString(item.title, comment: ""))
        cell.accessoryType = item.showsDisclosureIndicator ? .disclosureIndicator : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        let itemType = item.style
        
        guard let viewController = viewController(for: itemType), let navigationController = navigationController else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        viewController.title = NSLocalizedString(item.title, comment: "")
        let primaryNavigationController = type(of: navigationController).init(rootViewController: viewController)
        if viewController is ViewController10_Present {
            tableView.deselectRow(at: indexPath, animated: true)
            present(primaryNavigationController, animated: true, completion: nil)
        } else {
            if UIDevice.isPhoneDevice {
                viewController.hidesBottomBarWhenPushed = true
                navigationController.pushViewController(viewController, animated: true)
            } else {
                if let secondaryNavigationController = self.splitViewController?.viewControllers.last as? UINavigationController{
                    if !(secondaryNavigationController.viewControllers.last?.isKind(of: type(of: viewController)) ?? false) {
                        showDetailViewController(primaryNavigationController, sender: nil)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(sections[section].title, comment: "")
    }

}

extension FeatureTableViewController {
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .customDarkGray
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return .clear
    }
    
}
