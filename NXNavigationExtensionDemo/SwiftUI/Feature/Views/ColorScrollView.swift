//
//  ColorScrollView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/18.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct ColorScrollView: View {
    @Environment(\.colorScheme) private var colorScheme;
    @State private var selection = 0
    
    private var taps = ["Tap1", "Tap2"]
    private let hasHeader: Bool
    
    init(_ hasHeader: Bool = false) {
        self.hasHeader = hasHeader
    }
    
    var body: some View {
        contentView(hasHeader: hasHeader)
    }
    
    private func contentView(hasHeader: Bool) -> some View {
        let list = ForEach(0..<30) { index in
            NavigationLink {
                UpdateNavigationBar(NavigationFeatureItem(style: .updateNavigationBarForManually))
            } label: {
                ZStack {
                    HStack {
                        Text("Row: \(index + 1)").padding(.leading)
                        Spacer()
                        Image(systemName: "chevron.right").padding(.trailing)
                    }
                    VStack {
                        Spacer()
                        Color(UIColor.separator).frame(height: 1.0 / UIScreen.main.scale)
                    }
                }
            }
            .frame(height: 40)
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .background(Color( colorScheme == .dark ? UIColor.randomDark : UIColor.randomLight))
        }
        
        return ScrollView {
            VStack {
                if hasHeader {
                    Picker("", selection: $selection) {
                        ForEach(0..<taps.count) { index in
                            Text(self.taps[index]).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    Text("Value: \(taps[selection])")
                }
                list
            }
        }
    }
}

@available(iOS 13, *)
struct ColorScrollView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ColorScrollView()
        }
    }
}
