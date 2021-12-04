//
//  DrawerViewController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import UIKit

class DrawerViewController: BaseViewController {
    
    private lazy var contentViewController =  ViewController11_TableViewController()
    
    private lazy var closeDrawerButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "NavigationBarClose"), style: .plain, target: self, action: #selector(clickCloseDrawerButtonItem(_:)))
        item.tintColor = .white
        return item
    }()
    
    @objc
    private func clickCloseDrawerButtonItem(_ item: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "Drawer 🌈🌈🌈"
        navigationItem.rightBarButtonItem = closeDrawerButtonItem
        
        addChild(contentViewController)
        contentViewController.view.frame = view.frame
        view.addSubview(contentViewController.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // fix: 修复导航栏标题被 contentViewController 修改的问题
        nx_setNeedsNavigationBarAppearanceUpdate()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension DrawerViewController {
    
    override var nx_navigationBarBackgroundImage: UIImage? {
        return UIImage.navigationBarBackground
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
}
