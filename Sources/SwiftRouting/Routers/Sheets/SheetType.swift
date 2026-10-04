//
//  SheetType.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

/// The presentation style used by a sheet router.
public enum SheetType: Sendable {
    /// Presents the destination using SwiftUI's full-screen cover.
    case fullScreen
    /// Presents the destination using SwiftUI's sheet.
    case partial
}
