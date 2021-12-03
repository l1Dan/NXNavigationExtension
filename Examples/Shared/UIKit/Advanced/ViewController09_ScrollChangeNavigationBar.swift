//
//  ViewController09_ScrollChangeNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

protocol FakeNavigationBarDelegate: AnyObject {
    func fakeNavigationBar(_ navigationBar: FakeNavigationBar, didClickNavigationItemWith itemType: FakeNavigationBar.ItemType)
}

class FakeNavigationBar: UIView {
    
    enum ItemType { case back, add }
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "NavigationBarBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(clickBackButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "NavigationBarAdd")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(clickRightButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    private var navigationBarAlpha: CGFloat = 0.0
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    weak var delegate: FakeNavigationBarDelegate?
    
    func updateAlpha(_ alpha: CGFloat) {
        navigationBarAlpha = alpha
        let white = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let change = UIColor.customColor {
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } darkModeColor: {
            return UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        }
        backButton.tintColor = UIColor.mix(color1: change, color2: white, ratio: alpha)
        rightButton.tintColor = UIColor.mix(color1: change, color2: white, ratio: alpha)
        titleLabel.alpha = alpha
        titleLabel.textColor = change
    }
    
    @objc
    private func clickBackButton(_ button: UIButton) {
        delegate?.fakeNavigationBar(self, didClickNavigationItemWith: .back)
    }
    
    @objc
    private func clickRightButton(_ button: UIButton) {
        delegate?.fakeNavigationBar(self, didClickNavigationItemWith: .add)
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        titleLabel.alpha = 0.0
        
        [backButton, titleLabel, rightButton].forEach(addSubview)
        
        backButton.isHidden = !UIDevice.isPhoneDevice
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            backButton.leftAnchor.constraint(equalTo: leftAnchor),
            backButton.widthAnchor.constraint(equalToConstant: UIDevice.isPhoneDevice ? 44 : 0),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: backButton.rightAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightButton.leftAnchor),
        ])
        
        NSLayoutConstraint.activate([
            rightButton.topAnchor.constraint(equalTo: topAnchor),
            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightButton.rightAnchor.constraint(equalTo: rightAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAlpha(navigationBarAlpha)
    }
    
}

class ViewController09_ScrollChangeNavigationBar: CustomTableViewController, FakeNavigationBarDelegate {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "TableViewHeader"))
        imageView.sizeToFit()
        return imageView
    }()
    
    private lazy var fakeNavigationBar: FakeNavigationBar = {
        let fakeNavigationBar = FakeNavigationBar()
        fakeNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        fakeNavigationBar.delegate = self
        return fakeNavigationBar
    }()

    private var barStyle: UIStatusBarStyle = .lightContent
    private var barAlpha = CGFloat(0.0)
    
    private var navigationBarTitle: String?
    
    private var topConstraint: NSLayoutConstraint?
    private var leftConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = imageView
        
        navigationBarTitle = navigationItem.title
        fakeNavigationBar.title = navigationItem.title
        navigationItem.title = nil
        
        setNeedsStatusBarAppearanceUpdate()
        
        guard let nx_navigationBar = nx_navigationBar else { return }
        nx_navigationBar.contentView.addSubview(fakeNavigationBar)
        barAlpha = 0.0
        
        let contentView = nx_navigationBar.contentView
        
        topConstraint = fakeNavigationBar.topAnchor.constraint(equalTo: contentView.topAnchor)
        topConstraint?.isActive = true
        
        leftConstraint = fakeNavigationBar.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        leftConstraint?.isActive = true
        
        bottomConstraint = fakeNavigationBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint?.isActive = true
        
        rightConstraint = fakeNavigationBar.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        rightConstraint?.isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let nx_navigationBar = nx_navigationBar else { return }
        let maxHeight = nx_navigationBar.frame.height
        tableView.contentInset = UIEdgeInsets(top: -maxHeight, left: 0, bottom: 0, right: 0)
        
        var safeAreaInsets = navigationController?.navigationBar.layoutMargins
        if #available(iOS 11.0, *) {
            safeAreaInsets = navigationController?.navigationBar.safeAreaInsets
        }
        
        guard let safeAreaInsets = safeAreaInsets else { return }
        topConstraint?.constant = safeAreaInsets.top
        leftConstraint?.constant = safeAreaInsets.left
        bottomConstraint?.constant = safeAreaInsets.bottom
        rightConstraint?.constant = -safeAreaInsets.right
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
    // MARK: - UIScrollViewDelegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        guard let nx_navigationBar = nx_navigationBar else { return }
        
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            scrollView.contentOffset = .zero
        }
        
        let imageViewHeight = imageView.frame.height
        let navigationBarHeight = nx_navigationBar.frame.height
        let alpha = CGFloat.maximum(0.0, CGFloat.minimum(1.0, (offsetY - imageViewHeight + navigationBarHeight) / nx_navigationBar.frame.height ))
        barAlpha = alpha
        
        if #available(iOS 13.0, *) {
            if view.traitCollection.userInterfaceStyle == .dark {
                barStyle = .lightContent
            } else {
                barStyle = alpha > 0.0 ? .darkContent : .lightContent
            }
        } else {
            barStyle = alpha > 0.0 ? .default : .lightContent
        }
        setNeedsStatusBarAppearanceUpdate()
        nx_setNeedsNavigationBarAppearanceUpdate()
        fakeNavigationBar.updateAlpha(alpha)        
    }
    
    // MARK: - FakeNavigationBarDelegate
    
    func fakeNavigationBar(_ navigationBar: FakeNavigationBar, didClickNavigationItemWith itemType: FakeNavigationBar.ItemType) {
        switch itemType {
        case .back:
            navigationController?.nx_popViewController(animated: true)
        case .add:
            guard let navigationController = navigationController else { return }
            let newNavigationController = type(of: navigationController).init(rootViewController: ViewController10_Present())
            present(newNavigationController, animated: true, completion: nil)
        }
    }

}

extension ViewController09_ScrollChangeNavigationBar {
    
    override var nx_barTintColor: UIColor? {
        return .clear
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return .clear
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .systemBlue.withAlphaComponent(barAlpha)
    }
    
    override var nx_systemNavigationBarUserInteractionDisabled: Bool {
        return true
    }
    
}
