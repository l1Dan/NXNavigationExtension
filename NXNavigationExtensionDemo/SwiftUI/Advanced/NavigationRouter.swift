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

private enum PopType: String {
    case pop = "Pop"
    case popUntil = "PopUntil"
    case popToFirstUntil = "PopToFirstUntil"
    case popToLastUntil = "PopToLastUntil"
}

@available(iOS 13.0, *)
private struct NavigationShowPopTypeView: View {
    @Environment(\.colorScheme) private var colorScheme

    @Binding private var isPresented: Bool
    @Binding private var popType: PopType
    
    private let names: [String]
    private let context: NXNavigationRouter.Context
    private let onDismissed: (String) -> Void
    
    init(names: [String],
         context: NXNavigationRouter.Context,
         popType: Binding<PopType>,
         isPresented: Binding<Bool>,
         onDismissed: @escaping (String) -> Void) {
        var routeNames = names
        routeNames.insert("/", at: 0)
        self.names = routeNames
        self.context = context
        self._popType = popType
        self._isPresented = isPresented
        self.onDismissed = onDismissed
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = CGFloat.minimum(geometry.size.width, geometry.size.height) * 0.8
            ZStack {
                (colorScheme == .dark ? Color.white : Color.black).opacity(0.1).frame(width: geometry.size.width, height: geometry.size.height)
                VStack(spacing: 0) {
                    ForEach(names, id: \.self) { name in
                        Button {
                            onDismissed(name)
                            isPresented = false
                        } label: {
                            Text(name).frame(width: width, height: 44)
                        }
                        .disabled(buttonDisabled(routeName: name, popType: popType))
                        Color(UIColor.separator).frame(height: 1.0 / UIScreen.main.scale)
                    }
                }
                .background((colorScheme == .dark ? Color.black : Color.white).cornerRadius(20))
                .frame(width: width)
            }
            .onTapGesture {
                isPresented = false
            }
        }
    }
    
    private func canPop(_ routeName: String) -> Bool {
        if routeName == names[0] { return true }
        return NXNavigationRouter.of(context).destinationViewController(withRouteName: routeName, isReverse: true) != nil
    }
    
    private func buttonDisabled(routeName: String, popType: PopType) -> Bool {
        if routeName == names[0] && popType != .popUntil {
            return true
        }
        return !canPop(routeName)
    }
    
}


@available(iOS 13.0, *)
private struct NavigationDestinationRouteView: View {
    @State private var isPresented = false
    @State private var popType: PopType = .pop
    @State private var context: NXNavigationRouter.Context

    private let names = ["/index1", "/index2", "index3", "/custom", "custom2"]
    private let popTypes: [PopType] = [.pop, .popUntil, .popToFirstUntil, .popToLastUntil]
    private var randomDark = UIColor.randomDark
    private var randomLight = UIColor.randomLight
    
    private var popRouteNames: [String] {
        var names = self.names
        names.insert(NavigationFeatureItem.Style.navigationRouter.rawValue, at: 0)
        return names
    }
    
    private let title: String
    
    init(title: String) {
        self.title = title
        self.context = NXNavigationRouter.Context(routeName: title)
    }
    
    var body: some View {
        ZStack {
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
                        switch type {
                        case .pop: NXNavigationRouter.of(context).pop()
                        default:
                            popType = type
                            isPresented = true
                        }
                    } label: {
                        HStack {
                            Text(type.rawValue)
                            Spacer()
                            
                            if type != .pop {
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                }
            }.listStyle(.grouped)
            
            if isPresented {
                NavigationShowPopTypeView(names: popRouteNames, context: context, popType: $popType, isPresented: $isPresented) { routeName in
                    switch popType {
                    case .popUntil:
                        NXNavigationRouter.of(context).popUntil(routeName)
                    case .popToFirstUntil:
                        NXNavigationRouter.of(context).popToFirstUntil(routeName)
                    case .popToLastUntil:
                        NXNavigationRouter.of(context).popToLastUntil(routeName)
                    default:
                        NXNavigationRouter.of(context).popToRoot()
                    }
                    print(routeName)
                }
            }
        }
        .navigationBarTitle(title)
        .useNXNavigationView(context: $context,
                             onPrepareConfiguration: { configuration in
            let userInterfaceStyle = configuration.viewControllerPreferences.traitCollection?.userInterfaceStyle ?? .light
            configuration.navigationBarAppearance.backgroundColor = userInterfaceStyle == .dark ? randomDark : randomLight
            configuration.navigationBarAppearance.useSystemBackButton = true
        })
    }
    
}

@available(iOS 13.0, *)
struct NavigationRouter: View {
    private var randomDark = UIColor.randomDark
    private var randomLight = UIColor.randomLight
    
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        NavigationDestinationRouteView(title: item.title)
    }
}

@available(iOS 13.0, *)
struct NavigationRouter_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationRouter(NavigationFeatureItem(style: .navigationRouter))
        }
    }
}
