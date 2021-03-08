import SwiftUI
import AppKit

public enum Colors: String, Identifiable, Equatable, CaseIterable {
    case candy, breeze, midnight, sunset
    public var id: String { rawValue }
}

public enum DarkMode: String, Identifiable, Equatable, CaseIterable {
    case match, alwaysDark, alwaysLight
    public var id: String { rawValue }
}

public enum Padding: String, Identifiable, Equatable, CaseIterable {
    case sixteen = "16"
    case thirtyTwo = "32"
    case sixtyFour = "64"
    case oneTwentyEight = "128"
    public var id: String { rawValue }
}

public class Configuration {

    @AppStorage("colors", store: defaults) public var colors = Colors.midnight
    @AppStorage("background", store: defaults) public var background = true
    @AppStorage("darkMode", store: defaults) public var darkMode = DarkMode.match
    @AppStorage("padding", store: defaults) public var padding = Padding.thirtyTwo

    public init() {}

}

extension Configuration {

    public var resolvedDarkMode: String {
        let colorScheme = UserDefaults.standard.object(forKey: "AppleInterfaceStyle") as? String
        switch (darkMode, colorScheme) {
        case (.alwaysDark, _):
            return "true"
        case (.alwaysLight, _):
            return "false"
        case (.match, "Dark"):
            return "true"
        case (.match, _):
            return "false"
        }
    }

}


extension Configuration {

    private static let defaults = UserDefaults(suiteName: "Z72PRUAWF6.xray")

}
