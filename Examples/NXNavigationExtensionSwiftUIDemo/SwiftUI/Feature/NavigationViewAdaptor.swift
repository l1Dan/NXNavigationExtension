//
//  NavigationViewAdaptor.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2022/9/12.
//

import SwiftUI

struct NavigationViewAdaptor<Content: View>: View {
    
    private let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content()
            }
        } else {
            NavigationView {
                content()
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct NavigationViewAdaptor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewAdaptor {
            EmptyView()
        }
    }
}
