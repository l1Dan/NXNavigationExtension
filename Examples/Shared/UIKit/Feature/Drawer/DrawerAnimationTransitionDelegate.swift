//
//  DrawerAnimationTransitionDelegate.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import UIKit

class DrawerAnimationTransitionDelegate: NSObject {
    
    private lazy var animationController = DrawerAnimationController()
    
    private var viewController: UIViewController?
    
}

extension DrawerAnimationTransitionDelegate {
    
    func setupDrawer(with viewController: UIViewController, inView: UIView) {
        self.viewController = viewController
    }
    
    func openDrawer() {
        let navigationController = FeatureNavigationController(rootViewController: DrawerViewController())
        navigationController.transitioningDelegate = self
        navigationController.modalPresentationStyle = .custom
        viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func closeDrawer() {
        
    }
    
}

extension DrawerAnimationTransitionDelegate: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController.isReverse = true
        return animationController
    }
    
}
