//
//  HierarchyViewController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import UIKit

class HierarchyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private static let reuseIdentifier = String(describing: UITableViewCell.self)
    private static let chooseJumpTableViewHeight = CGFloat(44.0)

    private var chooseViewControllers: [UIViewController] = []
    private var completionHandler: ((UIViewController?) -> Void)?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        return tableView
    }()

    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(tableView)

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        widthConstraint = tableView.widthAnchor.constraint(equalToConstant: 0)
        widthConstraint?.isActive = true

        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let size = view.bounds.size
        let height = CGFloat(chooseViewControllers.count) * HierarchyViewController.chooseJumpTableViewHeight + 88.0

        let maxHeight = CGFloat.minimum(height, size.height - 150)
        let maxWidth = UIDevice.current.userInterfaceIdiom == .pad ? size.width * 0.5 : size.width * 0.8
        widthConstraint?.constant = maxWidth
        heightConstraint?.constant = maxHeight
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        dismiss(animated: false) { [weak self] in
            self?.completionHandler?(nil)
        }
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chooseViewControllers.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = HierarchyViewController.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.backgroundColor = nil
        if indexPath.row < chooseViewControllers.count {
            let index = (chooseViewControllers.count - 1) - indexPath.row
            let viewController = chooseViewControllers[index]
            cell.textLabel?.text = "(\(index))\(viewController.navigationItem.title ?? "")"
            cell.textLabel?.textColor = nil

            if let viewController = viewController as? BaseViewController {
                cell.backgroundColor = viewController.randomColor
            }
        } else {
            cell.textLabel?.text = "(*)Inserts to below a Instance"
            cell.textLabel?.textColor = UIColor.systemRed
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var viewController: UIViewController = ViewController07_UpdateNavigationBar()
        if indexPath.row < chooseViewControllers.count {
            let index = (chooseViewControllers.count - 1) - indexPath.row
            viewController = chooseViewControllers[index]
        }

        dismiss(animated: false) { [weak self] in
            self?.completionHandler?(viewController)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HierarchyViewController.chooseJumpTableViewHeight
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Selected ViewController for jump"
    }
}

extension HierarchyViewController {
    static func show(from viewController: UIViewController?, viewControllers: [UIViewController]?, completionHandler: ((UIViewController?) -> Void)? = nil) {
        guard let viewController, let viewControllers, !viewControllers.isEmpty else {
            return
        }

        let vc = HierarchyViewController()
        vc.chooseViewControllers = viewControllers
        vc.completionHandler = completionHandler
        vc.modalPresentationStyle = .custom
        viewController.present(vc, animated: false, completion: nil)
    }
}
