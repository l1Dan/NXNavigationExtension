//
//  FullPopGesture_ScrollView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import UIKit
import NXNavigationExtension

class FullPopGesture_ScrollView: BaseViewController, UIScrollViewDelegate {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.customColor { .randomLight } darkModeColor: { .randomDark }
        return scrollView
    }()
    
    private var imageNames: [String] = [] {
        didSet {
            let bounds = UIScreen.main.bounds
            for index in 0 ..< imageNames.count {
                let imageView = UIImageView(image: UIImage(named: imageNames[index]))
                imageView.frame = CGRect(x: bounds.width * CGFloat(index), y: 0, width: bounds.width, height: bounds.height)
                imageView.contentMode = .scaleAspectFit
                scrollView.addSubview(imageView)
                scrollView.contentSize = CGSize(width: bounds.width + bounds.width * CGFloat(index), height: bounds.height)
            }
        }
    }
    
    private var canBackAction = true
    
    private func setupContentWithSize(_ size: CGSize) {
        guard imageNames.count > 0 else { return }
        
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        for index in 0 ..< imageNames.count {
            let imageView = UIImageView(image: UIImage(named: imageNames[index]))
            imageView.frame = CGRect(x: size.width * CGFloat(index), y: 0, width: size.width, height: size.height)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            scrollView.contentSize = CGSize(width: size.width + size.width * CGFloat(index), height: size.height)
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    convenience init(imageNames: [String]) {
        self.init(nibName: nil, bundle: nil)
        self.imageNames = imageNames
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "(UIScrollView)\(NSLocalizedString("resolveGestureConflicts", comment: ""))"
        
        view.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        setupContentWithSize(UIScreen.main.bounds.size)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController {
            scrollView.panGestureRecognizer.require(toFail: navigationController.nx_fullScreenPopGestureRecognizer)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupContentWithSize(size)
    }
    

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= 0 {
            canBackAction = true
        } else {
            canBackAction = false
        }
    }

}

extension FullPopGesture_ScrollView {
    
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

extension FullPopGesture_ScrollView {
    func nx_navigationTransition(_ transitionViewController: UIViewController, navigationBackAction action: NXNavigationBackAction) -> Bool {
        if case .interactionGesture = action {
            return canBackAction
        }
        return true
    }
}
