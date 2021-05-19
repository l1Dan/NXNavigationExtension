//
//  ViewController13_Blur.swift
//  UNXNavigatorDemo
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

        unx_navigationBar.addSubview(blurView)
        
        blurView.topAnchor.constraint(equalTo: unx_navigationBar.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: unx_navigationBar.leftAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: unx_navigationBar.bottomAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: unx_navigationBar.rightAnchor).isActive = true
    }
    
    override var unx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }

}
