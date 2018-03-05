//
//  TLCompletionTextField.swift
//  Taylor
//
//  Created by Benjamin Pisano on 05/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class TLCompletionTextField: NSTextField, NSTextFieldDelegate {
    
    private var suggestionView: TLSuggestionView?
    
    override func awakeFromNib() {
        delegate = self
    }
    
    
    ////////////////
    // MARK: - UI //
    ////////////////
    
    func showSuggestions() {
        guard stringValue != "" && stringValue.last != " " else {
            removeTableView()
            return
        }
        
        let suggestions = TLAutoCompletion().suggestions(text: stringValue)
        if suggestions.count > 0 {
            showTableView()
            suggestionView?.set(suggestions: suggestions)
        }
        else {
            removeTableView()
        }
    }
    
    private func showTableView() {
        guard suggestionView == nil else {
            return
        }
        
        guard let sugg = NSView().named("TLSuggestionView") as? TLSuggestionView else {
            return
        }
        
        let height: CGFloat = 100
        let viewFrame = NSRect(x: frame.origin.x, y: frame.origin.y - height - 4, width: frame.width, height: height)
        
        sugg.frame = viewFrame
        suggestionView = sugg
        superview?.addSubview(sugg)
    }
    
    private func removeTableView() {
        guard let suggestionView = suggestionView else {
            return
        }
        
        suggestionView.removeFromSuperview()
        self.suggestionView = nil
    }
    
    
    ////////////////////////////////
    // MARK: - TextField Delegate //
    ////////////////////////////////
    
    override func controlTextDidChange(_ obj: Notification) {
        showSuggestions()
    }
    
    func didEnter() {
        guard let suggestionView = suggestionView else {
            return
        }
        
        let suggestion = suggestionView.selectedSuggestion()
        
        while stringValue.last != " " && stringValue.count > 0 {
            stringValue.removeLast()
        }
        stringValue.append(suggestion + " ")
        removeTableView()
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector.description == "insertNewline:" && suggestionView != nil {
            didEnter()
            textView.setSelectedRange(NSRange(location: textView.selectedRange().length, length: 0))
            textView.moveToEndOfLine(self)
            return true
        }
        else if commandSelector.description == "moveUp:" && suggestionView != nil {
            suggestionView?.selectPreviousSuggestion()
            return true
        }
        else if commandSelector.description == "moveDown:" && suggestionView != nil {
            suggestionView?.selectNextSuggestion()
            return true
        }
        return false
    }
}
