//
//  ViewController07_ScrollChangeNavigationBar.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController07_ScrollChangeNavigationBar: BaseTableViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "TableViewHeader"))
        imageView.sizeToFit()
        return imageView
    }()
    
    private lazy var fakeNavigationBar: FakeNavigationBar = {
        let fakeNavigationBar = FakeNavigationBar(frame: .zero)
        fakeNavigationBar.delegate = self
        fakeNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        return fakeNavigationBar
    }()
    
    private var barStyle: UIStatusBarStyle = .lightContent
    private var navigationBarTitle: String?
    
    private var topConstraint: NSLayoutConstraint?
    private var leftConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = imageView
        
        navigationBarTitle = navigationItem.title
        fakeNavigationBar.title = navigationItem.title
        navigationItem.title = nil
        
        let view = UIView(frame: CGRect(x: 10, y: 40, width: 44, height: 44))
        view.backgroundColor = .red
        nx_navigationBar.addContainerSubview(fakeNavigationBar)
        
        nx_navigationBar.alpha = 0.0
        barStyle = .lightContent
        
        setNeedsStatusBarAppearanceUpdate()

        let containerView = nx_navigationBar.containerView
        
        topConstraint = fakeNavigationBar.topAnchor.constraint(equalTo: containerView.topAnchor)
        topConstraint?.isActive = true
        
        leftConstraint = fakeNavigationBar.leftAnchor.constraint(equalTo: containerView.leftAnchor)
        leftConstraint?.isActive = true
        
        bottomConstraint = fakeNavigationBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        bottomConstraint?.isActive = true
        
        rightConstraint = fakeNavigationBar.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        rightConstraint?.isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let maxHeight = nx_navigationBar.frame.height
        tableView.contentInset = UIEdgeInsets(top: -maxHeight, left: 0.0, bottom: 0.0, right: 0.0)
        
        let safeAreaInsets = navigationController?.navigationBar.safeAreaInsets ?? .zero
        topConstraint?.constant = safeAreaInsets.top
        leftConstraint?.constant = safeAreaInsets.left
        bottomConstraint?.constant = safeAreaInsets.bottom
        rightConstraint?.constant = -safeAreaInsets.right
    }
    
    override var nx_barTintColor: UIColor? {
        return .clear
    }
    
    override var nx_containerViewWithoutNavigtionBar: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
}

extension ViewController07_ScrollChangeNavigationBar {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            scrollView.contentOffset = .zero
        }

        let imageViewHeight = imageView.frame.height
        let navigationBarHeight = nx_navigationBar.frame.height
        let alpha = CGFloat.maximum(0.0, CGFloat.minimum(1.0, (offsetY - imageViewHeight + navigationBarHeight) / nx_navigationBar.frame.height))

        nx_navigationBar.alpha = alpha

        if #available(iOS 13.0, *) {
            if view.traitCollection.userInterfaceStyle == .dark {
                barStyle = .lightContent
            } else {
                barStyle = alpha > 0.0 ? .darkContent : .lightContent
            }
        } else {
            barStyle = alpha > 0.0 ? .default : .lightContent
        }

        setNeedsStatusBarAppearanceUpdate()
        fakeNavigationBar.updateNavigationBar(alpha: alpha)
    }
    
}

extension ViewController07_ScrollChangeNavigationBar: FakeNavigationBarDelegate {
    
    func fakeNavigationBar(_ navigationBar: FakeNavigationBar, didClickNavigationItemWithItemType itemType: FakeNavigationBar.ItemType) {
        switch itemType {
        case .back:
            navigationController?.nx_triggerSystemBackButtonHandler()
        case .add:
            guard let navigationController = navigationController else { return }
            let controller = type(of: navigationController).init(rootViewController: ViewController12_Modal())
            present(controller, animated: true, completion: nil)
        }
    }
    
}
