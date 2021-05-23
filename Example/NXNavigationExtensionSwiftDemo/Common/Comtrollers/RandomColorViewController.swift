//
//  RandomColorViewController.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class RandomColorViewController: BaseViewController {
    
    private static let randomColorButtonWidthAndHeight = CGFloat(160.0)
    
    private lazy var randomColorButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = RandomColorViewController.randomColorButtonWidthAndHeight * 0.5
        button.layer.borderWidth = 5.0
        button.setTitle("Update", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickRandomColorButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private var isDarkMode: Bool {
        return randomColorButton.tag % 2 == 0
    }
    
    private var currentRandomColor: UIColor?
    private var lightRandomColor = UIColor.randomLight
    private var darkRandomColor = UIColor.randomDark
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        currentRandomColor = .customDynamic(lightMode: { self.lightRandomColor }, darkMode: { self.darkRandomColor })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = navigationItem.title == nil ? String(describing: type(of: self)).toClassName : navigationItem.title
        view.addSubview(randomColorButton)
        
        updateRandomColorButtonState()
        randomColorButton.widthAnchor.constraint(equalToConstant: RandomColorViewController.randomColorButtonWidthAndHeight).isActive = true
        randomColorButton.heightAnchor.constraint(equalToConstant: RandomColorViewController.randomColorButtonWidthAndHeight).isActive = true
        randomColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        randomColorButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
    
    override var randomColor: UIColor? {
        return currentRandomColor
    }
    
    override var nx_barTintColor: UIColor? {
        return isDarkMode ? .white : .black
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: isDarkMode ? UIColor.white : UIColor.black]
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return currentRandomColor
    }

}

extension RandomColorViewController {
    
    private func updateRandomColorButtonState() {
        randomColorButton.layer.borderColor = currentRandomColor?.cgColor
        randomColorButton.setTitleColor(currentRandomColor, for: .normal)
        if #available(iOS 13.0, *) {
            randomColorButton.setTitleColor(currentRandomColor?.resolvedColor(with: view.traitCollection), for: .normal)
        }
    }
    
}

@objc
extension RandomColorViewController {
    
    private func clickRandomColorButton(_ button: UIButton) {
        button.tag += 1
        
        lightRandomColor = .randomLight
        darkRandomColor = .randomDark
        updateRandomColorButtonState()
        nx_setNeedsNavigationBarAppearanceUpdate()
        setNeedsStatusBarAppearanceUpdate()
    }
    
}
