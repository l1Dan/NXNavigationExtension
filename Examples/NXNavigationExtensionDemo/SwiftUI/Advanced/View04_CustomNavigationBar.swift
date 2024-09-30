//
//  View04_CustomNavigationBar.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/18.
//

import SwiftUI
import NXNavigationExtensionSwiftUI

@available(iOS 14.0, *)
struct FakeNavigationView<Content>: View where Content : View {
    @Environment(\.presentationMode) private var presentationMode;
    @Environment(\.colorScheme) private var colorScheme;
    
    @State private var statusBarHeight = 0.0
    @State private var isActive = false
    
    private let content : () -> Content
    private let title: Text
    private var action: (() -> Void)?
    
    init(title: Text, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
        self.statusBarHeight = UIApplication.shared.statusBarHeight
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                content()
                VStack(spacing: 0.0) {
                    Color.red
                        .frame(width: geometry.size.width, height: UIApplication.shared.statusBarHeight)
                        .opacity(0.9)
                    ZStack {
                        Color.blue.opacity(0.9)
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 8.0)
                            }.accentColor(colorScheme == .dark ? Color.white : Color.black)
                            
                            Spacer()
                            title.accentColor(colorScheme == .dark ? Color.white : Color.black)
                            Spacer()
                            
                            NavigationLink(isActive: $isActive) {
                                View07_UpdateNavigationBar(NavigationFeatureItem(style: .updateNavigationBar))
                            } label: {
                                Button {
                                    isActive = true
                                } label: {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 22, height: 22)
                                        .padding(.trailing, 8.0)
                                }.accentColor(colorScheme == .dark ? Color.white : Color.black)
                            }
                        }
                        .padding([.leading, .trailing], 8.0)
                    }
                    .frame(width: geometry.size.width, height: 44.0)
                    Spacer()
                }
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .edgesIgnoringSafeArea(.top)
    }
}

@available(iOS 14.0, *)
struct View04_CustomNavigationBar: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        FakeNavigationView(title: Text(item.title)) {
            ColorListView()
        }
        .useNXNavigationView { configuration in
            configuration.viewControllerPreferences.translucentNavigationBar = true
        }
    }
}

@available(iOS 14.0, *)
#Preview {
    AdaptiveNavigationView {
        View04_CustomNavigationBar(NavigationFeatureItem(style: .customNavigationBar))
    }
}
