import SwiftUI
import XrayKit

struct ContentView: View {

    @State var configuration = Configuration()

    var body: some View {
        Form {
            Picker("Theme", selection: configuration.$colors) {
                ForEach(Colors.allCases) { colors in
                    Text(colors.rawValue).tag(colors)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Picker("Dark Mode", selection: configuration.$darkMode) {
                ForEach(DarkMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Picker("Padding", selection: configuration.$padding) {
                ForEach(Padding.allCases) { padding in
                    Text(padding.rawValue).tag(padding)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Toggle("Background", isOn: configuration.$background)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
