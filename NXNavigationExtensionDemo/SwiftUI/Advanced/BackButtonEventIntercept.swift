//
//  BackButtonEventIntercept.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

import NXNavigationExtension

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct BackButtonEventIntercept: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode;
    
    @State private var context: NXNavigationRouter.Context = .init(routeName: "")
    @State private var navigationPopToViewController = false
    @State private var interactiveType = NavigationEventItemType.all
    @State private var isPresented: Bool = false
    
    private let events = NavigationEventItem.items
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        List {
            Section {
                ForEach(events, id:\.self.title) { item in
                    Button {
                        interactiveType = item.type
                    } label: {
                        HStack {
                            Text("\(item.title)").foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            if interactiveType == item.type {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } footer: {
                Button {
                    NXNavigationRouter.of(context).nx.pop()
                } label: {
                    Text("调用 “nx_pop” 方法返回")
                        .font(.system(size: 18))
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 60)
                }
                .overlay(RoundedRectangle(cornerRadius: 10, style: .circular).strokeBorder(Color.blue, lineWidth: 2.0))
            }
        }
        .listStyle(.grouped)
        .navigationBarTitle(item.title)
        .alert(isPresented: $isPresented, content: {
            let cancel = Alert.Button.cancel(Text("取消"))
            let destructive = Alert.Button.destructive(Text("返回")) {
                presentationMode.wrappedValue.dismiss()
            }
            return Alert(title:Text("提示"), message: Text("是否继续返回？"), primaryButton: destructive, secondaryButton: cancel)
        })
        .useNXNavigationView(context: $context, onPrepareConfiguration: { configuration in
            configuration.navigationBarAppearance.backgroundImage = UIImage(named: "NavigationBarBackgound88")
            configuration.navigationBarAppearance.tintColor = .white
            configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            configuration.navigationBarAppearance.useSystemBackButton = true
        }, onWillPopViewController: { interactiveType in
            if self.interactiveType == .all {
                isPresented = true
                return false
            } else if self.interactiveType == .backButtonAction && interactiveType == .backButtonAction {
                isPresented = true
                return false
            } else if self.interactiveType == .backButtonMenuAction && interactiveType == .backButtonMenuAction {
                isPresented = true
                return false
            } else if self.interactiveType == .popGestureRecognizer && interactiveType == .popGestureRecognizer {
                isPresented = true
                return false
            } else if self.interactiveType == .callNXPopMethod && interactiveType == .callNXPopMethod {
                isPresented = true
                return false
            }
            return true
        })
    }
}

@available(iOS 13, *)
struct BackButtonEventIntercept_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonEventIntercept(NavigationFeatureItem(style: .backButtonEventIntercept))
    }
}
