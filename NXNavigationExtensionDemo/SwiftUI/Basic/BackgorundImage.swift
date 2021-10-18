//
//  BackgorundImage.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0.0, *)
struct BackgorundImage: View {
    @State private var isPresented = false
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .useNXNavigationView(configuration: { configuration in
                configuration.navigationBarAppearance.backgroundImage = UIImage(named: "NavigationBarBackgound88")
                configuration.navigationBarAppearance.tintColor = .white
                configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                return configuration
            }, willPopViewController: { interactiveType in
                switch interactiveType {
                case .backButtonAction:
                    print("backButtonAction")
                case .backButtonMenuAction:
                    print("backButtonMenuAction")
                case .popGestureRecognizer:
                    print("popGestureRecognizer")
                case .callNXPopMethod:
                    print("callNXPopMethod")
                @unknown default:
                    return true
                }
                
                return true
            })
    }
}

@available(iOS 13.0.0, *)
struct BackgorundImage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BackgorundImage(NavigationFeatureItem(style: .backgorundImage))
        }
    }
}