//
//  EditorType.swift
//  OpenInTerminalCore
//
//  Created by Jianing Wang on 2019/4/21.
//  Copyright © 2019 Jianing Wang. All rights reserved.
//

import Foundation

public enum EditorType: String {
    
    case vscode = "VSCode"
    case atom = "Atom"
    case sublime = "Sublime"
    case vscodium = "VSCodium"
    case bbedit = "BBEdit"
    case vscodeInsiders = "VSCodeInsiders"
    case textMate = "TextMate"
    case cotEditor = "CotEditor"
    case macVim = "MacVim"
    case phpStorm = "PhpStorm"
    
    public var fullName: String {
        switch self {
        case .vscode:
            return "Visual Studio Code"
        case .atom:
            return "Atom"
        case .sublime:
            return "Sublime Text"
        case .vscodium:
            return "VSCodium"
        case .bbedit:
            return "BBEdit"
        case .vscodeInsiders:
            return "Visual Studio Code - Insiders"
        case .textMate:
            return "TextMate"
        case .cotEditor:
            return "CotEditor"
        case .macVim:
            return "MacVim"
        case .phpStorm:
            return "PhpStorm"
        }
    }
    
    public var bundleId: String {
        switch self {
        case .vscode:
            return "com.microsoft.VSCode"
        case .atom:
            return "com.github.atom"
        case .sublime:
            return "com.sublimetext.3"
        case .vscodium:
            return "com.visualstudio.code.oss"
        case .bbedit:
            return "com.barebones.bbedit"
        case .vscodeInsiders:
            return "com.microsoft.VSCodeInsiders"
        case .textMate:
            return "com.macromates.TextMate"
        case .cotEditor:
            return ""
        case .macVim:
            return ""
        case .phpStorm:
            return ""
        }
    }
    
    public func instance() -> Editor {
        switch self {
        case .vscode:
            return VSCodeApp()
        case .atom:
            return AtomApp()
        case .sublime:
            return SublimeApp()
        case .vscodium:
            return VSCodiumApp()
        case .bbedit:
            return BBEditApp()
        case .vscodeInsiders:
            return VSCodeInsidersApp()
        case .textMate:
            return TextMateApp()
        case .cotEditor:
            return CotEditorApp()
        case .macVim:
            return MacVimApp()
        case .phpStorm:
            return PhpStormApp()
        }
    }
}

public extension EditorType {
    
    init?(by fullName: String) {
        switch fullName {
        case "Visual Studio Code":
            self = .vscode
        case "Atom":
            self = .atom
        case "Sublime Text":
            self = .sublime
        case "VSCodium":
            self = .vscodium
        case "BBEdit":
            self = .bbedit
        case "Visual Studio Code - Insiders":
            self = .vscodeInsiders
        case "TextMate":
            self = .textMate
        case "CotEditor":
            self = .cotEditor
        case "MacVim":
            self = .macVim
        case "PhpStorm":
            self = .phpStorm
        default:
            return nil
        }
    }
    
}

extension EditorType: Scriptable {
    
    public func getScript() -> String {
        let escapedName = self.fullName.nameSpaceEscaped
        
        let script = """
        tell application "Finder"
            set finderSelList to selection as alias list
            
            if finderSelList ≠ {} then
                set theSelected to item 1 of finderSelList
                set thePath to POSIX path of (contents of theSelected)
            end if
            
            if finderSelList = {} then
                tell application "Finder"
                    try
                        set thePath to POSIX path of ((target of front Finder window) as text)
                    on error
                        set thePath to POSIX path of (path to desktop)
                    end try
                end tell
            end if
            
        end tell

        do shell script "open -a \(escapedName) " & quoted form of thePath
        """
        
        return script
    }
    
}

extension String {
    
    /// handle space in name
    var nameSpaceEscaped: String {
        let replaced = self.replacingOccurrences(of: " ", with: "\\\\ ")
        return replaced
    }
}
