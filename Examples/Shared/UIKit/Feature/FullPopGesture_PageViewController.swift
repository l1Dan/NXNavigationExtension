//
//  FullPopGesture_PageViewController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import UIKit
import NXNavigationExtension

class FullPopGesture_PageViewController: BaseViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private lazy var pageViewController: UIPageViewController = {
        let options = [UIPageViewController.OptionsKey.spineLocation: UIPageViewController.SpineLocation.none]
        let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        viewController.delegate = self
        viewController.dataSource = self
        return viewController
    }()
    
    private var pageViewControllers: [FullPopGesture_ScrollView] = []
    private var imageNames: [String] = []
    
    private var canBackAction = true
    
    private var currentViewController: FullPopGesture_ScrollView?
    
    private func setupContent() {
        guard imageNames.count > 0 else { return }
        
        for index in 0 ..< imageNames.count {
            pageViewControllers.append(FullPopGesture_ScrollView(imageNames: [imageNames[index]]))
        }
        
        guard pageViewControllers.count > 0 else { return }
        
        currentViewController = pageViewControllers.first
        guard let currentViewController = currentViewController else { return }

        pageViewController.setViewControllers([currentViewController], direction: .forward, animated: false, completion: nil)
        view.addSubview(pageViewController.view)
    }
    
    private func indexOf(viewController: FullPopGesture_ScrollView) -> Int? {
        return pageViewControllers.firstIndex(of: viewController)
    }
    
    convenience init(imageNames: [String]) {
        self.init(nibName: nil, bundle: nil)
        self.imageNames = imageNames
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "(UIPageViewController)\(NSLocalizedString("resolveGestureConflicts", comment: ""))"

        for subview in pageViewController.view.subviews {
            if let subview = subview as? UIScrollView, let navigationController = navigationController {
                subview.panGestureRecognizer.require(toFail: navigationController.nx_fullScreenPopGestureRecognizer)
            }
        }
        setupContent()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        for vc in pageViewControllers {
            vc.viewWillTransition(to: size, with: coordinator)
        }
    }
    

    // MARK: - UIPageViewControllerDelegate & UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? FullPopGesture_ScrollView,
              var index = indexOf(viewController: vc), index > 0 else { return nil }
        index -= 1
        
        currentViewController = pageViewControllers[index]
        return currentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? FullPopGesture_ScrollView, var index = indexOf(viewController: vc) else { return nil }
        index += 1
        
        if index == pageViewControllers.count { return nil }
        currentViewController = pageViewControllers[index]
        return currentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }
        
        guard let lhs = pageViewController.viewControllers?.first,
              let rhs = pageViewControllers.first else { return }
        canBackAction = (lhs == rhs)
    }

}

extension FullPopGesture_PageViewController {
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
    override var nx_shadowColor: UIColor? {
        return .clear
    }
    
    override var nx_enableFullScreenInteractivePopGesture: Bool {
        return true
    }
}

extension FullPopGesture_PageViewController {
    func nx_navigationTransition(_ transitionViewController: UIViewController, navigationBackAction action: NXNavigationBackAction) -> Bool {
        if case .interactionGesture = action {
            return canBackAction
        }
        return true
    }
}
