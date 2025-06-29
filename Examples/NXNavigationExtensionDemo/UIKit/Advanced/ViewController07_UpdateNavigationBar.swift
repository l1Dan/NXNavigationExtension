//
//  ViewController07_UpdateNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import NXNavigationExtension
import UIKit

class ViewController07_UpdateNavigationBar: BaseViewController {
    private static let randomColorButtonWidthAndHeight = CGFloat(160.0)

    private lazy var randomColorButton: UIButton = {
        let randomColorButton = UIButton(type: .custom)
        randomColorButton.backgroundColor = .clear
        randomColorButton.translatesAutoresizingMaskIntoConstraints = false
        randomColorButton.layer.cornerRadius = ViewController07_UpdateNavigationBar.randomColorButtonWidthAndHeight * 0.5
        randomColorButton.layer.borderWidth = 5.0
        randomColorButton.setTitle("Update", for: .normal)
        randomColorButton.addTarget(self, action: #selector(clickRandomColorButton(_:)), for: .touchUpInside)
        return randomColorButton
    }()

    private lazy var backButtonTitle = "Custom"
    private lazy var randomDark = UIColor.randomDark
    private lazy var randomLight = UIColor.randomLight

    private var currentRandom: UIColor {
        return UIColor.customColor { [weak self] in
            return self?.randomLight ?? UIColor.randomLight
        } darkModeColor: { [weak self] in
            return self?.randomDark ?? UIColor.randomDark
        }
    }

    private var isDarkMode: Bool {
        return randomColorButton.tag % 2 == 0
    }

    @objc
    private func clickRandomColorButton(_ button: UIButton) {
        button.tag += 1
        backButtonTitle = "😜(\(button.tag))"
        randomDark = UIColor.randomDark
        randomLight = UIColor.randomLight

        updateRandomColorButtonState()
        nx_setNeedsNavigationBarAppearanceUpdate()
        setNeedsStatusBarAppearanceUpdate()
    }

    private func updateRandomColorButtonState() {
        randomColorButton.layer.borderColor = currentRandom.cgColor
        randomColorButton.setTitleColor(currentRandom, for: .normal)
        if #available(iOS 13.0, *) {
            randomColorButton.setTitleColor(currentRandom.resolvedColor(with: view.traitCollection), for: .normal)
        }
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        navigationItem.title = NSLocalizedString(NavigationFeatureItem.Style.updateNavigationBar.rawValue, comment: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(randomColorButton)

        updateRandomColorButtonState()

        NSLayoutConstraint.activate([
            randomColorButton.widthAnchor.constraint(equalToConstant: ViewController07_UpdateNavigationBar.randomColorButtonWidthAndHeight),
            randomColorButton.heightAnchor.constraint(equalToConstant: ViewController07_UpdateNavigationBar.randomColorButtonWidthAndHeight),
            randomColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomColorButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return isDarkMode ? .lightContent : .darkContent
        } else {
            return isDarkMode ? .lightContent : .default
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateRandomColorButtonState()
    }

    override var randomColor: UIColor {
        return currentRandom
    }
}

extension ViewController07_UpdateNavigationBar {
    override var nx_navigationBarBackgroundColor: UIColor? {
        return currentRandom
    }

    override var nx_barTintColor: UIColor? {
        return isDarkMode ? .white : .black
    }

    override var nx_titleTextAttributes: [NSAttributedString.Key: Any]? {
        return [NSAttributedString.Key.foregroundColor: nx_barTintColor ?? (isDarkMode ? .white : .black)]
    }

    override var nx_useSystemBackButton: Bool {
        return true
    }

    override var nx_systemBackButtonTitle: String? {
        return backButtonTitle
    }
}
