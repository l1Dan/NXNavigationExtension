//
//  BaseNavigationController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import NXNavigationExtension
import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.semanticContentAttribute = .forceRightToLeft
//        navigationBar.semanticContentAttribute = .forceRightToLeft
    }

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

    deinit {
        print("Deinit: \(type(of: self))")
    }
}

class OtherNavigationController: BaseNavigationController {}

class BaseViewController: UIViewController {
    private lazy var dark = UIColor.randomDark
    private lazy var light = UIColor.randomLight

    private(set) lazy var randomColor: UIColor = .customColor { [weak self] in
        return self?.light ?? .randomLight
    } darkModeColor: { [weak self] in
        return self?.dark ?? .randomDark
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customColor(lightModeColor: { .white }, darkModeColor: { .black })
//        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
//        view.semanticContentAttribute = .forceRightToLeft
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
//    }

    deinit {
        print("Deinit: \(type(of: self))")
    }
}

extension BaseViewController: NXNavigationTransitionDelegate {
    override var nx_barTintColor: UIColor? {
        return .customTitle
    }

    override var nx_titleTextAttributes: [NSAttributedString.Key: Any]? {
        return [NSAttributedString.Key.foregroundColor: nx_barTintColor ?? .customTitle]
    }

    override var nx_shadowColor: UIColor? {
        return UIColor.customColor { .lightGray } darkModeColor: { .lightGray.withAlphaComponent(0.65) }
    }

    func nx_navigationTransition(_ transitionViewController: UIViewController, navigationTransitionState state: NXNavigationTransitionState) {
        print("\(type(of: transitionViewController)) - \(state)")
    }
}
