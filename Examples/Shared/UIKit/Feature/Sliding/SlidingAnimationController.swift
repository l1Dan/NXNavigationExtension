//
//  SlidingAnimationController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2024/1/21.
//

import UIKit

class SlidingAnimationController: NSObject {
    private lazy var backgroundColorView: UIVisualEffectView = {
        var effect = UIBlurEffect(style: .extraLight)
        if #available(iOS 13.0, *) {
            effect = UIBlurEffect(style: .systemChromeMaterial)
        }

        let backgroundColorView = UIVisualEffectView(effect: effect)
        backgroundColorView.alpha = 0.0
        return backgroundColorView
    }()

    var isReverse = false
}

extension SlidingAnimationController {
    private func executeForwardsAnimation(using transitionContext: UIViewControllerContextTransitioning?, fromVC: UIViewController, toVC: UIViewController) {
        let containerView = transitionContext?.containerView

        containerView?.addSubview(toVC.view)

        backgroundColorView.frame = containerView?.bounds ?? .zero
        backgroundColorView.alpha = 0.0
        containerView?.insertSubview(backgroundColorView, belowSubview: toVC.view)

        let toViewFinalFrame = transitionContext?.finalFrame(for: toVC) ?? .zero
        toVC.view.transform = CGAffineTransform(translationX: -toViewFinalFrame.width, y: 0)

        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear) { [weak self] in
            toVC.view.transform = .identity
            fromVC.view.transform = CGAffineTransform(translationX: toViewFinalFrame.width, y: 0)

            self?.backgroundColorView.alpha = 1.0
        } completion: { finished in
            transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled ?? true))
        }
    }

    private func executeReverseAnimation(using transitionContext: UIViewControllerContextTransitioning?, fromVC: UIViewController, toVC: UIViewController) {
        let fromViewFinalFrame = transitionContext?.finalFrame(for: fromVC) ?? .zero
        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear) { [weak self] in
            toVC.view.transform = .identity
            fromVC.view.transform = CGAffineTransform(translationX: -fromViewFinalFrame.width, y: 0)

            self?.backgroundColorView.alpha = 0.0
        } completion: { [weak self] finished in
            self?.isReverse = false
            if transitionContext?.transitionWasCancelled ?? true {
            } else {
                self?.backgroundColorView.alpha = 1.0
            }
            transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled ?? true))
        }
    }
}

extension SlidingAnimationController: UIViewControllerAnimatedTransitioning {
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
