//
//  ViewController02_FullScreenPopGestureEnable.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import NXNavigationExtension
import UIKit

class ViewController02_FullScreenPopGestureEnable: BaseViewController {
    private lazy var contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var scrollViewTypeButton: UIButton = {
        let scrollViewTypeButton = UIButton()
        scrollViewTypeButton.translatesAutoresizingMaskIntoConstraints = false
        scrollViewTypeButton.backgroundColor = .brown
        scrollViewTypeButton.setTitle("Use UIScrollView", for: .normal)
        scrollViewTypeButton.addTarget(self, action: #selector(clickUseScrollViewButton(_:)), for: .touchUpInside)
        return scrollViewTypeButton
    }()

    private lazy var pageViewControllerTypeButton: UIButton = {
        let pageViewControllerTypeButton = UIButton()
        pageViewControllerTypeButton.translatesAutoresizingMaskIntoConstraints = false
        pageViewControllerTypeButton.backgroundColor = .brown
        pageViewControllerTypeButton.setTitle("Use UIPageViewController", for: .normal)
        pageViewControllerTypeButton.addTarget(self, action: #selector(clickUsePageViewControllerButton(_:)), for: .touchUpInside)
        return pageViewControllerTypeButton
    }()

    private lazy var imageNames: [String] = Array(0 ..< 3).map { "0\($0)" }

    @objc
    private func clickUseScrollViewButton(_ button: UIButton) {
        navigationController?.pushViewController(FullPopGesture_ScrollView(imageNames: imageNames), animated: true)
    }

    @objc
    private func clickUsePageViewControllerButton(_ button: UIButton) {
        navigationController?.pushViewController(FullPopGesture_PageViewController(imageNames: imageNames), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(contentView)
        contentView.addArrangedSubview(scrollViewTypeButton)
        contentView.addArrangedSubview(pageViewControllerTypeButton)

        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }
}

extension ViewController02_FullScreenPopGestureEnable {
    override var nx_enableFullScreenInteractivePopGesture: Bool {
        return true
    }
}
