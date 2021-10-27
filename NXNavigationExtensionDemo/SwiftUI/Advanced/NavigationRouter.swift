//
//  NavigationRouter.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/25.
//

import NXNavigationExtension

#if canImport(SwiftUI)
import SwiftUI
#endif

private enum PopTypes: String {
    case pop = "Pop"
    case popTo = "PopTo"
    case popFirst = "PopFirst"
    case popLast = "PopLast"
    case popIndex = "PopIndex"
}


@available(iOS 13, *)
private struct NavigationShowPopTypeView: View {
    
    var body: some View {
        Text("1111")
    }
    
}


@available(iOS 13, *)
private struct NavigationDestinationRouteView: View {
    @State private var context: NXNavigationContext?

    private let names = ["/index1", "/index2", "index3", "/custom", "custom2"]
    private let popTypes: [PopTypes] = [.pop, .popTo, .popFirst, .popLast, .popIndex]
    private var randomDark = UIColor.randomDark
    private var randomLight = UIColor.randomLight
    
    private let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        List {
            Section {
                ForEach(names, id: \.self) { name in
                    NavigationLink {
                        NavigationDestinationRouteView(title: name)
                    } label: {
                        Text(name)
                    }
                }
            }
            
            ForEach(popTypes, id: \.self.rawValue) { type in
                Button {
                    guard let context = context else { return }
                    
                    switch type {
                    case .pop: NXNavigationRouter.of(context).pop()
                    default: NXNavigationRouter.of(context).pop("/")
                    }
                } label: {
                    Text(type.rawValue)
                }
            }
        }
        .navigationBarTitle(title)
        .useNXNavigationView(routeName: title, onPrepareConfiguration: { configuration in
            let userInterfaceStyle = configuration.viewControllerPreferences.traitCollection?.userInterfaceStyle ?? .light
            configuration.navigationBarAppearance.backgroundColor = userInterfaceStyle == .dark ? randomDark : randomLight
            configuration.navigationBarAppearance.useSystemBackButton = true
        }, onContextChanged: { context in
            self.context = context
        })
    }
    
}

@available(iOS 13, *)
struct NavigationRouter: View {
    private var randomDark = UIColor.randomDark
    private var randomLight = UIColor.randomLight
    
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        NavigationDestinationRouteView(title: item.title)
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                let userInterfaceStyle = configuration.viewControllerPreferences.traitCollection?.userInterfaceStyle ?? .light
                configuration.navigationBarAppearance.backgroundColor = userInterfaceStyle == .dark ? randomDark : randomLight
                configuration.navigationBarAppearance.useSystemBackButton = true
            })
    }
}

@available(iOS 13, *)
struct NavigationRouter_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationRouter(NavigationFeatureItem(style: .navigationRouter))
        }
    }
}
