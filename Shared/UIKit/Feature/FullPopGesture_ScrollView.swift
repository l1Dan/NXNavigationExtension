//
//  FullPopGesture_ScrollView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import UIKit

class FullPopGesture_ScrollView: BaseViewController, UIScrollViewDelegate {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.customColor(lightModeColor: {
            return .randomLight
        }, darkModeColor: {
            return .randomDark
        })
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
    
    private var disableInteractivePopGesture = false
    private var enableFullScreenInteractivePopGesture = true
    
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

        navigationItem.title = "(UIScrollView)解决手势冲突"
        
        view.addSubview(scrollView)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupContentWithSize(UIScreen.main.bounds.size)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        // Step1: if use screen edge pop gesture
//        disableInteractivePopGesture = false
        enableFullScreenInteractivePopGesture = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController {
            // Step2: if use screen edge pop gesture
//            scrollView.panGestureRecognizer.require(toFail: navigationController.interactivePopGestureRecognizer)
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
            // Step4: if use screen edge pop gesture
//            disableInteractivePopGesture = false
            enableFullScreenInteractivePopGesture = true
        } else {
            // Step5: if use screen edge pop gesture
//            disableInteractivePopGesture = true
            enableFullScreenInteractivePopGesture = false
        }
    }

}

extension FullPopGesture_ScrollView {
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return .clear
    }
    
    // Step3: if use screen edge pop gesture
//    override var nx_disableInteractivePopGesture: Bool {
//        return disableInteractivePopGesture
//    }
    
    override var nx_enableFullScreenInteractivePopGesture: Bool {
        return enableFullScreenInteractivePopGesture
    }
    
}
