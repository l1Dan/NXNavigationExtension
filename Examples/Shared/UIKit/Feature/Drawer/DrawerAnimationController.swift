//
//  DrawerAnimationController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import UIKit

class DrawerAnimationController: NSObject {
    
    private lazy var backgroundColorView: UIVisualEffectView = {
        var effect = UIBlurEffect(style: .extraLight)
        if #available(iOS 13.0, *) {
            effect = UIBlurEffect(style: .systemChromeMaterial)
        }
        
        let backgroundColorView = UIVisualEffectView(effect: effect)
        backgroundColorView.alpha = 0.0
        return backgroundColorView
    }()

    var isReverse: Bool = false
    
}

extension DrawerAnimationController {
    
    private func executeForwardsAnimation(using transitionContext: UIViewControllerContextTransitioning?, fromVC: UIViewController, toVC: UIViewController) {
        let containerView = transitionContext?.containerView
        containerView?.insertSubview(toVC.view, aboveSubview: fromVC.view)
        
        backgroundColorView.frame = containerView?.bounds ?? .zero
        backgroundColorView.alpha = 0.0
        containerView?.insertSubview(backgroundColorView, belowSubview: toVC.view)
        
        let toViewFinalFrame = transitionContext?.finalFrame(for: toVC) ?? .zero
        let screenBounds = fromVC.view.frame
        toVC.view.frame = toViewFinalFrame.offsetBy(dx: -screenBounds.width, dy: 0)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear) { [weak self] in
            toVC.view.frame = screenBounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: screenBounds.width * 0.1))
            fromVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self?.backgroundColorView.alpha = 1.0
        } completion: { finished in
            transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled ?? true))
        }
    }
    
    private func executeReverseAnimation(using transitionContext: UIViewControllerContextTransitioning?, fromVC: UIViewController, toVC: UIViewController) {
        // fix: white/black screen
        if fromVC.modalPresentationStyle == .fullScreen {
            let containerView = transitionContext?.containerView
            containerView?.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        
        let fromViewFinalFrame = transitionContext?.finalFrame(for: fromVC) ?? .zero
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear) { [weak self] in
            toVC.view.transform = .identity
            
            fromVC.view.frame = fromViewFinalFrame.offsetBy(dx: -fromViewFinalFrame.width, dy: 0)
            
            self?.backgroundColorView.alpha = 0.0
        } completion: { [weak self] finished in
            self?.isReverse = false
            if transitionContext?.transitionWasCancelled ?? true {
                toVC.view.transform = .identity
                
                self?.backgroundColorView.alpha = 1.0
            } else {
                self?.backgroundColorView.alpha = 1.0
            }
            transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled ?? true))
        }
    }
    
}

extension DrawerAnimationController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        if isReverse {
            executeReverseAnimation(using: transitionContext, fromVC: fromVC, toVC: toVC)
        } else {
            executeForwardsAnimation(using: transitionContext, fromVC: fromVC, toVC: toVC)
        }
    }
    
}
