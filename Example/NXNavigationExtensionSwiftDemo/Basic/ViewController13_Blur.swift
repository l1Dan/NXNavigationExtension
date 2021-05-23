//
//  ViewController13_Blur.swift
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2021/5/7.
//

import UIKit

class ViewController13_Blur: BaseTableViewController {
    
    private lazy var blurView: UIVisualEffectView = {
        var effect: UIBlurEffect! = nil
        if #available(iOS 13.0, *) {
            effect = UIBlurEffect(style: .systemChromeMaterial)
        } else {
            effect = UIBlurEffect(style: .extraLight)
        }
        
        let blurView = UIVisualEffectView(effect: effect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.customDynamic(lightMode: { .red }, darkMode: { .gray })
        blurView.contentView.addSubview(contentView)
        blurView.contentView.alpha = 0.5
        
        contentView.topAnchor.constraint(equalTo: blurView.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: blurView.rightAnchor).isActive = true
        
        return blurView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        nx_navigationBar.addSubview(blurView)
        
        blurView.topAnchor.constraint(equalTo: nx_navigationBar.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: nx_navigationBar.leftAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: nx_navigationBar.bottomAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: nx_navigationBar.rightAnchor).isActive = true
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }

}
