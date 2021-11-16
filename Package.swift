// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "NXNavigationExtension",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "NXNavigationExtension", targets: ["NXNavigationExtension"]),
        .library(name: "NXNavigationExtensionSwiftUI", targets: ["NXNavigationExtensionSwiftUI"])
    ],
    targets: [
        .target(
            name: "NXNavigationExtension",
            path: "NXNavigationExtension",
            exclude: [
                "Info.plist"
            ],
            publicHeadersPath: "include",
            cSettings: [
                CSetting.headerSearchPath("include"),
                CSetting.headerSearchPath("Core"),
                CSetting.headerSearchPath("Private"),
                CSetting.headerSearchPath("Support SwiftUI"),
            ],
            linkerSettings: [.linkedFramework("UIKit")]
        ),
        .target(
            name: "NXNavigationExtensionSwiftUI",
            dependencies: ["NXNavigationExtension"],
            path: "NXNavigationExtensionSwiftUI"
        )
    ],
    swiftLanguageVersions: [.v5]
)
