//
//  FeatureListView.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//


import SwiftUI

@available(iOS 14.0, *)
struct FeatureListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var presentingModal = false
    private let sections:[NavigationFeatureSection]
    
    init(_ sections: [NavigationFeatureSection]) {
        self.sections = sections
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            listView().listStyle(.insetGrouped)
        } else {
            listView().listStyle(.grouped)
        }
    }
    
    private func listView() -> some View {
        List {
            ForEach(sections, id:\.self.title) { section in
                Section {
                    ForEach(0..<section.items.count, id: \.self) { index in
                        if section.items[index].style == .present {
                            Button(action: {
                                presentingModal = true
                            }, label: {
                                Text(titleForItem(section.items[index], at: index))
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            }).sheet(isPresented: $presentingModal) {
                                AdaptiveNavigationView {
                                    View10_Present(section.items[index], presentedAsModal: $presentingModal)
                                }
                            }
                        } else {
                            NavigationLink {
                                FeatureDetailView(section.items[index])
                            } label: {
                                Text(titleForItem(section.items[index], at: index))
                            }
                        }
                    }
                } header: {
                    Text(section.title)
                }
            }
        }
    }
    
    private func titleForItem(_ item: NavigationFeatureItem, at index: Int) -> String {
        return String(format: "%02zd: %@", index + 1, NSLocalizedString(item.title, comment: ""))
    }
}

@available(iOS 14.0, *)
#Preview {
    AdaptiveNavigationView {
        FeatureListView(NavigationFeatureSection.sections(for: false))
    }
}
