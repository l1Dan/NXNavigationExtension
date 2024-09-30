//
//  SlidingNavigationController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2024/1/21.
//

import UIKit

protocol SlidingInteractiveNavigation {
    var swipeDirectionAction: SlidingSwipeDirectionAction { get }
}

enum SlidingSwipeDirectionAction {
    case left(handler: () -> Void)
    case right(handler: () -> Void)
}


fileprivate class SlidingNavigationManager: NSObject {
    static let `default` = SlidingNavigationManager()

    private(set) lazy var animationController = SlidingAnimationController()
    private(set) lazy var interactionController = SlidingInteractionController()
}

extension SlidingNavigationManager: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var viewController: UIViewController? = presented
        if let presented = viewController as? SlidingNavigationController {
            if presented.viewControllers.count > 1 {
                return nil
            }
            viewController = presented.viewControllers.last
        }
        if viewController is SlidingInteractiveNavigation {
            return animationController
        }
        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var viewController: UIViewController? = dismissed
        if let dismissed = viewController as? SlidingNavigationController {
            if dismissed.viewControllers.count > 1 {
                return nil
            }
            viewController = dismissed.viewControllers.last
        }
        if viewController is SlidingInteractiveNavigation {
            animationController.isReverse = true
            return animationController
        }
        return nil
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard animator is SlidingAnimationController else { return nil }

        return interactionController.isInteracting ? interactionController : nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard animator is SlidingAnimationController else { return nil }

        return interactionController.isInteracting ? interactionController : nil
    }
}

class SlidingNavigationController: BaseNavigationController {
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        return pan
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = SlidingNavigationManager.default
        view.addGestureRecognizer(panGestureRecognizer)
    }
}

extension SlidingNavigationController {
    private var animationController: SlidingAnimationController {
        return SlidingNavigationManager.default.animationController
    }

    private var interactionController: SlidingInteractionController {
        return SlidingNavigationManager.default.interactionController
    }
}

extension SlidingNavigationController {
    @objc
    private func handlePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let gestureView = gesture.view else { return }

        let flickThreshold: CGFloat = 700.0
        let distanceThreshold: CGFloat = 0.3

        let translation = gesture.translation(in: gesture.view?.superview)
        let velocity = gesture.velocity(in: gesture.view)
        var percent = abs(translation.x / gestureView.bounds.size.width)
        percent = CGFloat.minimum(CGFloat.maximum(percent, 0.0), 1.0)

        switch gesture.state {
        case .began:
            if let currentViewController = viewControllers.last as? SlidingInteractiveNavigation {
                let rightToLeftSwipe = velocity.x < 0
                interactionController.isInteracting = true
                interactionController.isRightToLeftSwipe = rightToLeftSwipe
                if case let .right(handler) = currentViewController.swipeDirectionAction, rightToLeftSwipe {
                    handler()
                }
                if case let .left(handler) = currentViewController.swipeDirectionAction, !rightToLeftSwipe {
                    handler()
                }
            }
        case .changed:
            guard interactionController.isInteracting else { return }
            if percent >= 1.0 { percent = 0.99 }
            // 解决手势接近屏幕边缘时，页面来回拉扯问题
            if interactionController.isRightToLeftSwipe && translation.x > 0 ||
                !interactionController.isRightToLeftSwipe && translation.x < 0 {
                interactionController.update(0.0)
            } else {
                interactionController.update(percent)
            }
        case .cancelled:
            guard interactionController.isInteracting else { return }
            interactionController.isInteracting = false
            interactionController.cancel()
        case .ended:
            guard interactionController.isInteracting else { return }
            // 解决手势快速滑动到屏幕边缘时，页面完成/取消不正确问题
            if abs(percent) > distanceThreshold || abs(velocity.x) > flickThreshold {
                if interactionController.isRightToLeftSwipe && translation.x > 0 ||
                    !interactionController.isRightToLeftSwipe && translation.x < 0 {
                    interactionController.cancel()
                } else {
                    interactionController.finish()
                }
            } else {
                interactionController.cancel()
            }
            interactionController.isInteracting = false
        default: break
        }
    }
}

extension SlidingNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard viewControllers.count == 1,
              let pan = gestureRecognizer as? UIPanGestureRecognizer,
              let viewController = viewControllers.last as? SlidingInteractiveNavigation else { return false }

        let velocity = pan.velocity(in: pan.view)
        // 限制只能左右滑动
        guard abs(velocity.x) > abs(velocity.y) else { return false }
        switch viewController.swipeDirectionAction {
        case .left:
            if velocity.x > 0 {
                return true
            }
        case .right:
            if velocity.x < 0 {
                return true
            }
        }
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let otherGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer,
              let scrollView = otherGestureRecognizer.view as? UIScrollView,
              gestureRecognizer == panGestureRecognizer else {
            return false
        }

        guard viewControllers.count == 1,
              let viewController = viewControllers.last as? SlidingInteractiveNavigation else { return false }
        let offsetX = scrollView.contentOffset.x
        // 滑动到 UIScrollView 最边缘才能触发
        switch viewController.swipeDirectionAction {
        case .left:
            if offsetX <= 0 {
                return true
            }
        case .right:
            if offsetX >= scrollView.contentSize.width - scrollView.bounds.width {
                return true
            }
        }
        return false
    }
}
