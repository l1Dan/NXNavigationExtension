//
//  View03_BackButtonEventIntercept.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

import SwiftUI
import NXNavigationExtension
import NXNavigationExtensionSwiftUI

@available(iOS 14.0, *)
struct View03_BackButtonEventIntercept: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode;
    
    @State private var context: NXNavigationRouter.Context = .init(routeName: "")
    @State private var navigationPopToViewController = false
    @State private var selectedItemType = NavigationBackEvent.State.all
    @State private var isPresented: Bool = false
    
    private let events = NavigationBackEvent.items
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        List {
            Section {
                ForEach(events, id:\.self.title) { item in
                    Button {
                        selectedItemType = item.state
                    } label: {
                        HStack {
                            Text(LocalizedStringKey(item.title)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            if selectedItemType == item.state {
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
                    Text(LocalizedStringKey("popWithCallNXPopMethod"))
                        .font(.system(size: 18))
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 60)
                }
                .overlay(RoundedRectangle(cornerRadius: 10, style: .circular).strokeBorder(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2.0))
            }
        }
        .listStyle(.grouped)
        .navigationBarTitle(LocalizedStringKey(item.title))
        .alert(isPresented: $isPresented, content: {
            let cancel = Alert.Button.cancel(Text(LocalizedStringKey("cancel")))
            let destructive = Alert.Button.destructive(Text(LocalizedStringKey("yes"))) {
                presentationMode.wrappedValue.dismiss()
            }
            return Alert(title:Text(LocalizedStringKey("tips")), message: Text(LocalizedStringKey("message")), primaryButton: destructive, secondaryButton: cancel)
        })
        .useNXNavigationView(context: $context, onPrepareConfiguration: { configuration in
            configuration.navigationBarAppearance.backgroundImage = UIImage(named: "NavigationBarBackground88")
            configuration.navigationBarAppearance.tintColor = .white
            configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            configuration.navigationBarAppearance.useSystemBackButton = true
        }, onBackActionHandler: { action in
            if selectedItemType == .clickBackButton && action == .clickBackButton ||
                selectedItemType == .clickBackButtonMenu && action == .clickBackButtonMenu ||
                selectedItemType == .interactionGesture && action == .interactionGesture ||
                selectedItemType == .callingNXPopMethod && action == .callingNXPopMethod ||
                selectedItemType == .all {
                isPresented = true
                return false
            }
            return true
        })
    }
}

@available(iOS 14.0, *)
#Preview {
    View03_BackButtonEventIntercept(NavigationFeatureItem(style: .backButtonEventIntercept))
}
