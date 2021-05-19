//
//  ViewController06_ClickEventHitToBack.swift
//  UNXNavigatorSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController06_ClickEventHitToBack: BaseTableViewController {
    
    private lazy var tableHeaderView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .customGroupedBackground
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["First", "Second"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .customLightGray
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.customDarkGray], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.customLightGray], for: .selected)
        segmentedControl.addTarget(self, action: #selector(changeSegmentedControl(_:)), for: .valueChanged)
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .customDarkGray
        } else {
            segmentedControl.tintColor = .customDarkGray
        }
        return segmentedControl
    }()
    
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nil
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableHeaderView.addSubview(segmentedControl)
        
        segmentedControl.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor, constant: -4).isActive = true
        
        leftConstraint = segmentedControl.leftAnchor.constraint(equalTo: tableHeaderView.leftAnchor)
        leftConstraint?.isActive = true
        
        rightConstraint = segmentedControl.rightAnchor.constraint(equalTo: tableHeaderView.rightAnchor)
        rightConstraint?.priority = .defaultHigh
        rightConstraint?.isActive = true
        
        heightConstraint = segmentedControl.heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint?.isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let navigationBarFrame = navigationController?.navigationBar.frame ?? .zero
        
        let tableHeaderViewX = navigationBarFrame.minX
        let tableHeaderViewY = navigationBarFrame.minY
        let tableHeaderViewWidth = navigationBarFrame.width
        let tableHeaderViewHeight = tableHeaderViewY + navigationBarFrame.height
        tableHeaderView.frame = CGRect(x: tableHeaderViewX, y: tableHeaderViewY, width: tableHeaderViewWidth, height: tableHeaderViewHeight)
        tableView.tableHeaderView = tableHeaderView
        
        let safeAreaInsets = self.navigationController?.navigationBar.safeAreaInsets ?? .zero
        heightConstraint?.constant = navigationBarFrame.height * 0.8
        leftConstraint?.constant = safeAreaInsets.left
        rightConstraint?.constant = -safeAreaInsets.right
    }
    
    override var unx_hidesNavigationBar: Bool {
        return true
    }
    
    override var unx_enableFullScreenInteractivePopGesture: Bool {
        return true
    }

}

@objc
extension ViewController06_ClickEventHitToBack {
    
    private func changeSegmentedControl(_ segmentedControl: UISegmentedControl) {
        print(segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "")
    }
    
}
