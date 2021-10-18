//
//  CustomNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/18.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0.0, *)
struct FakeNavigationBar<Content>: View where Content : View {
    @Environment(\.presentationMode) private var presentationMode;
    @Environment(\.colorScheme) private var colorScheme;
    @State private var isActive = false
    
    private let content : () -> Content
    private let title: Text
    private var action: (() -> Void)?
    
    init(@ViewBuilder content: @escaping () -> Content, title: Text) {
        self.content = content
        self.title = title
    }
    
    var body: some View {
        ZStack {
            content()
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(Color.blue)
                        .opacity(0.9)
                        .blur(radius: 1.0)
                        .frame(height: geometry.safeAreaInsets.bottom + 44.0)
                }
                VStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.bottom)
                    Spacer()
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .padding(EdgeInsets(top: 0, leading: 8.0, bottom: 0, trailing: 8.0))
                        }.accentColor(colorScheme == .dark ? Color.white : Color.black)

                        Spacer()
                        title.accentColor(colorScheme == .dark ? Color.white : Color.black)
                        Spacer()
                        
                        NavigationLink(isActive: $isActive) {
                            UpdateNavigationBar()
                        } label: {
                            Button {
                                isActive = true
                            } label: {
                                Image(systemName: "plus")
                                    .padding(EdgeInsets(top: 0, leading: 8.0, bottom: 0, trailing: 8.0))
                            }.accentColor(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                    Spacer()
                }
                .frame(height: geometry.safeAreaInsets.bottom + 44.0)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

@available(iOS 13.0.0, *)
struct CustomNavigationBar: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        FakeNavigationBar(content: {
            List(0..<30) { index in
                Text("Content: \(index)")
            }
        }, title: Text(item.title)).useNXNavigationView { configuration in
            configuration.viewControllerPreferences.translucentNavigationBar = true
        }
    }
}

@available(iOS 13.0.0, *)
struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomNavigationBar(NavigationFeatureItem(style: .customNavigationBar))
        }
    }
}
