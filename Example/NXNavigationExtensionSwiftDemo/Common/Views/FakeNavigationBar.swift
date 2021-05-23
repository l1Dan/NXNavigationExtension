//
//  FakeNavigationBar.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

protocol FakeNavigationBarDelegate: AnyObject {
    func fakeNavigationBar(_ navigationBar: FakeNavigationBar, didClickNavigationItemWithItemType itemType: FakeNavigationBar.ItemType)
}

class FakeNavigationBar: UIView {

    enum ItemType {
        case back, add
    }
    
    weak var delegate: FakeNavigationBarDelegate?
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    private var navigationBarAlpha = CGFloat(0.0)
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "NavigationBarBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(clickBackButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "NavigationBarAdd")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(clickAddButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewContent()
        addViewContent()
        addViewConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateNavigationBar(alpha: navigationBarAlpha)
    }
    
}

extension FakeNavigationBar {
    
    private func setupViewContent() {
        backgroundColor = .clear
        titleLabel.alpha = 0.0
        backButton.isHidden = !UIDevice.isPhone
    }
    
    private func addViewContent() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(addButton)
    }
    
    private func addViewConstraint() {
        backButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: UIDevice.isPhone ? 44.0 : 0.0).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: backButton.rightAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: addButton.leftAnchor).isActive = true
     
        addButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        addButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
    }
    
}

@objc
extension FakeNavigationBar {
    
    private func clickBackButton(_ button: UIButton) {
        delegate?.fakeNavigationBar(self, didClickNavigationItemWithItemType: .back)
    }
    
    private func clickAddButton(_ button: UIButton) {
        delegate?.fakeNavigationBar(self, didClickNavigationItemWithItemType: .add)
    }
    
}

extension FakeNavigationBar {
    
    func updateNavigationBar(alpha: CGFloat) {
        navigationBarAlpha = alpha
        
        let white = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 ) // 不要使用 .white
        let change = UIColor.customDynamic {
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // .black
        } darkMode: {
            return UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) // .red
        }
        
        backButton.tintColor = UIColor.mix(color1: change, color2: white, ratio: alpha)
        addButton.tintColor = UIColor.mix(color1: change, color2: white, ratio: alpha)
        titleLabel.alpha = alpha
    }
    
}
