//
//  ColorScrollView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/18.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0.0, *)
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
//            .edgesIgnoringSafeArea(.top)
    }
    
    private func contentView(hasHeader: Bool) -> some View {
        let list = ForEach(0..<30) { index in
            VStack(alignment: .leading) {
                Text("Row: \(index + 1)")
                    .padding(EdgeInsets(top: 10, leading: 8.0, bottom: 10.0, trailing: 8.0))
                Color(UIColor.separator).frame(height: 0.3)
            }
            .background(Color( colorScheme == .dark ? UIColor.randomDark : UIColor.randomLight))
        }
        
        return ScrollView {
            VStack {
                if hasHeader {
                    Picker("", selection: $selection) {
                        ForEach(0..<taps.count) { index in
                            Text(self.taps[index]).tag(index)
                        }
                    }.pickerStyle(.segmented)
                    Text("Value: \(taps[selection])")
                }
                list
            }
        }
    }
}

@available(iOS 13.0.0, *)
struct ColorScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ColorScrollView()
    }
}
