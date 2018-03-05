//
//  TLSuggestionView.swift
//  Taylor
//
//  Created by Benjamin Pisano on 05/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class TLSuggestionView: NSView {

    @IBOutlet weak var tableView: NSTableView!
    
    private var suggestions = [String]()
    
    override func awakeFromNib() {
        configureUI()
    }
    
    
    //////////////
    // MARK: UI //
    //////////////
    
    private func configureUI() {
        wantsLayer = true
        shadow = NSShadow()
        layer?.shadowColor = NSColor.black.cgColor
        layer?.shadowRadius = 5
        layer?.shadowOpacity = 0.1
        layer?.shadowOffset = CGSize(width: 0, height: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.wantsLayer = true
        tableView.backgroundColor = NSColor.white
        tableView.enclosingScrollView?.layer?.cornerRadius = 4
        tableView.enclosingScrollView?.layer?.masksToBounds = true
    }
    
    
    ///////////////////////////////
    // MARK: - Tableview actions //
    ///////////////////////////////
    
    func set(suggestions sugg: [String]) {
        suggestions = sugg
        tableView.reloadData()
        tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
    }
    
    func selectedSuggestion() -> String {
        return suggestions[tableView.selectedRow]
    }
    
    func selectNextSuggestion() {
        if tableView.selectedRow + 1 >= suggestions.count {
            tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        }
        else {
            tableView.selectRowIndexes(IndexSet(integer: tableView.selectedRow + 1), byExtendingSelection: false)
        }
    }
    
    func selectPreviousSuggestion() {
        if tableView.selectedRow - 1 < 0 {
            tableView.selectRowIndexes(IndexSet(integer: suggestions.count - 1), byExtendingSelection: false)
        }
        else {
            tableView.selectRowIndexes(IndexSet(integer: tableView.selectedRow - 1), byExtendingSelection: false)
        }
    }
}


extension TLSuggestionView: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = NSView().named("TLSuggestionCell") as? TLSuggestionCell else {
            return nil
        }
        
        cell.textLabel.stringValue = suggestions[row]
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 26
    }
}
