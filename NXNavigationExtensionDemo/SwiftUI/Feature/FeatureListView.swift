//
//  FeatureListView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//


import SwiftUI

@available(iOS 13.0, *)
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
                    ForEach(0..<section.items.count) { index in
                        if section.items[index].style == .present {
                            Button(action: {
                                presentingModal = true
                            }, label: {
                                Text(String(format: "%02zd: %@", index + 1, section.items[index].title))
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            }).sheet(isPresented: $presentingModal) {
                                NavigationView {
                                    Present(section.items[index], presentedAsModal: $presentingModal)
                                }
                            }
                        } else {
                            NavigationLink {
                                FeatureDetailView(section.items[index])
                            } label: {
                                Text(String(format: "%02zd: %@", index + 1, section.items[index].title))
                            }
                        }
                    }
                } header: {
                    Text(section.title)
                }
            }
        }
    }
}

@available(iOS 13.0, *)
struct FeatureListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeatureListView(NavigationFeatureSection.sections(for: false))
        }
    }
}
