//
//  ViewController13_CustomBlurNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController13_CustomBlurNavigationBar: CustomTableViewController {
    
    private lazy var gaussianBlurView: UIVisualEffectView = {
        var effect = UIBlurEffect(style: .extraLight)
        if #available(iOS 13.0, *) {
            effect = UIBlurEffect(style: .systemChromeMaterial)
        }
        let gaussianBlurView = UIVisualEffectView(effect: effect)
        gaussianBlurView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.customColor { .purple } darkModeColor: { .brown }
        gaussianBlurView.contentView.addSubview(contentView)
        gaussianBlurView.contentView.alpha = 0.5
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: gaussianBlurView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: gaussianBlurView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: gaussianBlurView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: gaussianBlurView.trailingAnchor),
        ])
        
        return gaussianBlurView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let nx_navigationBar = nx_navigationBar else { return }
        nx_navigationBar.addSubview(gaussianBlurView)
        NSLayoutConstraint.activate([
            gaussianBlurView.topAnchor.constraint(equalTo: nx_navigationBar.topAnchor),
            gaussianBlurView.leadingAnchor.constraint(equalTo: nx_navigationBar.leadingAnchor),
            gaussianBlurView.bottomAnchor.constraint(equalTo: nx_navigationBar.bottomAnchor),
            gaussianBlurView.trailingAnchor.constraint(equalTo: nx_navigationBar.trailingAnchor),
        ])
    }
    
}

extension ViewController13_CustomBlurNavigationBar {
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
}
