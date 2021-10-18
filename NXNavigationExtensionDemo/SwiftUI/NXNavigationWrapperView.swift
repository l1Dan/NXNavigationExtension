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
struct NXNavigationPopToViewControllerKey: EnvironmentKey {
    static var defaultValue = false
}

@available(iOS 13.0, *)
struct NXNavigationPopToRootViewControllerKey: EnvironmentKey {
    static var defaultValue = false
}

@available(iOS 13.0, *)
extension EnvironmentValues {
    var navigationPopToViewController: Bool {
        get { self[NXNavigationPopToViewControllerKey.self] }
        set { self[NXNavigationPopToViewControllerKey.self] = newValue }
    }
}

@available(iOS 13.0, *)
extension EnvironmentValues {
    var navigationPopToRootViewController: Bool {
        get { self[NXNavigationPopToRootViewControllerKey.self] }
        set { self[NXNavigationPopToRootViewControllerKey.self] = newValue }
    }
}

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
    private let configuration: (NXNavigationConfiguration) -> NXNavigationConfiguration
    private var willPopViewController: ((NXNavigationInteractiveType) -> Bool)?

    init(configuration: @escaping (NXNavigationConfiguration) -> NXNavigationConfiguration,
         willPopViewController:  ((NXNavigationInteractiveType) -> Bool)? = nil) {
        self.configuration = configuration
        self.willPopViewController = willPopViewController
    }
    
    func makeUIView(context: Context) -> NXNavigationVirtualView {
        virtualView.prepareConfigurationCallback = prepareConfigurationCallback;
        virtualView.willPopViewController = willPopViewController
        print(context.environment.navigationPopToViewController)
        return virtualView
    }
    
    func prepareConfigurationCallback(viewController: UIViewController, configuration: NXNavigationConfiguration) -> NXNavigationConfiguration {
        let newConfiguration = self.configuration(configuration)
        
        viewController.nx_setNeedsNavigationBarAppearanceUpdate()
        viewController.setNeedsStatusBarAppearanceUpdate()
        return newConfiguration
    }
    
    func updateUIView(_ uiView: NXNavigationVirtualView, context: Context) {
        print(context.environment.navigationPopToViewController)
        // Nothing...
    }
    
}

@available(iOS 13.0, *)
extension View {
    
    func useNXNavigationView(configuration: @escaping (NXNavigationConfiguration) -> NXNavigationConfiguration,
                             willPopViewController: ((NXNavigationInteractiveType) -> Bool)? = nil) -> some View {
        ZStack {
            if #available(iOS 15.0, *) {
                overlay {
                    NXNavigationWrapperView(configuration: configuration, willPopViewController: willPopViewController)
                        .frame(width: 0, height: 0)
                }
            } else {
                overlay(
                    NXNavigationWrapperView(configuration: configuration, willPopViewController: willPopViewController)
                        .frame(width: 0, height: 0)
                )
            }
        }
    }
    
    func navigationPopToViewController(_ dismiss: Bool) -> some View {
        environment(\.navigationPopToViewController, dismiss)
    }
    
    func navigationPopToRootViewController(_ dismiss: Bool) -> some View {
        environment(\.navigationPopToRootViewController, dismiss)
    }
    
}

@available(iOS 13.0, *)
struct NXNavigationBarWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
