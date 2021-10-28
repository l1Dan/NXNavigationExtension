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
    case popTo = "PopTo"
    case popFirst = "PopFirst"
    case popLast = "PopLast"
    case popIndex = "PopIndex"
}

@available(iOS 13, *)
private struct NavigationShowPopTypeView: View {
    @Environment(\.colorScheme) private var colorScheme

    @Binding private var isPresented: Bool
    @Binding private var popType: PopType
    
    private let names: [String]
    private let onDismissed: (String) -> Void
    
    init(names: [String], popType: Binding<PopType>, isPresented: Binding<Bool>, onDismissed: @escaping (String) -> Void) {
        var routeNames = names
        routeNames.insert("/", at: 0)
        self.names = routeNames
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
                        .disabled((name == names[0]) && (popType != .popTo))
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
    
}


@available(iOS 13, *)
private struct NavigationDestinationRouteView: View {
    @State private var isPresented = false
    @State private var popType: PopType = .pop
    @State private var context: NXNavigationContext?

    private let names = ["/index1", "/index2", "index3", "/custom", "custom2"]
    private let popTypes: [PopType] = [.pop, .popTo, .popFirst, .popLast, .popIndex]
    private var randomDark = UIColor.randomDark
    private var randomLight = UIColor.randomLight
    
    private let title: String
    
    init(title: String) {
        self.title = title
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
                        guard let context = context else { return }
                        
                        switch type {
                        case .pop: NXNavigationRouter.of(context).pop()
                        case .popTo, .popFirst, .popLast, .popIndex:
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
                NavigationShowPopTypeView(names: names, popType: $popType, isPresented: $isPresented) { name in
                    guard let context = context else { return }
                    NXNavigationRouter.of(context).pop(name)
                    print(name)
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
