//
//  NXNavigationWrapperView.swift
//  NXNavigationExtensionSwiftUI
//
//  Created by lidan on 2021/9/24.
//

import NXNavigationExtension

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
class NXNavigationVirtualView: NXNavigationVirtualWrapperView {
    
    var willPopViewController: ((NXNavigationInteractiveType) -> Bool)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nx_navigationController(_ navigationController: UINavigationController,
                                          willPop viewController: UIViewController,
                                          interactiveType: NXNavigationInteractiveType) -> Bool {
        return self.willPopViewController?(interactiveType) ?? true
    }
}

@available(iOS 13.0, *)
struct NXNavigationWrapperView: UIViewRepresentable {
    typealias UIViewType = NXNavigationVirtualView
    
    private let virtualView = NXNavigationVirtualView()
    private let configurationCallback: (NXNavigationConfiguration) -> Void
    private var willPopViewController: ((NXNavigationInteractiveType) -> Bool)?

    init(configurationCallback: @escaping (NXNavigationConfiguration) -> Void,
         willPopViewController:  ((NXNavigationInteractiveType) -> Bool)? = nil) {
        self.configurationCallback = configurationCallback
        self.willPopViewController = willPopViewController
    }
    
    func makeUIView(context: Context) -> NXNavigationVirtualView {
        virtualView.prepareConfigurationCallback = prepareConfigurationCallback;
        virtualView.willPopViewController = willPopViewController
        return virtualView
    }
    
    func prepareConfigurationCallback(viewController: UIViewController, configuration: NXNavigationConfiguration) {
        configurationCallback(configuration)
        viewController.nx_setNeedsNavigationBarAppearanceUpdate()
    }
    
    func updateUIView(_ uiView: NXNavigationVirtualView, context: Context) {
        // Nothing...
    }
    
}

@available(iOS 13.0, *)
extension View {
    
    func useNXNavigationView(configurationCallback: @escaping (NXNavigationConfiguration) -> Void) -> some View {
        useNXNavigationView(configurationCallback: configurationCallback) { _ in return true }
    }
    
    func useNXNavigationView(configurationCallback: @escaping (NXNavigationConfiguration) -> Void,
                             willPopViewController: @escaping ((NXNavigationInteractiveType) -> Bool)) -> some View {
        ZStack {
            if #available(iOS 15.0, *) {
                overlay {
                    NXNavigationWrapperView(configurationCallback: configurationCallback, willPopViewController: willPopViewController)
                        .frame(width: 0, height: 0)
                }
            } else {
                overlay(
                    NXNavigationWrapperView(configurationCallback: configurationCallback, willPopViewController: willPopViewController)
                        .frame(width: 0, height: 0)
                )
            }
        }
    }
        
}

@available(iOS 13.0, *)
struct NXNavigationBarWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
