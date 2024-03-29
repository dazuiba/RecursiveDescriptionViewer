/*
 RecursiveDescriptionViewer
 Copyright (C) 2016  Cristian Filipov
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import Cocoa

final class OutlineViewController: NSViewController, NSOutlineViewDataSource, DocumentBased, NSOutlineViewDelegate {
    
    @IBOutlet weak var outlineView: NSOutlineView!

    var model: Desc?

    weak var document: Document? {
        didSet {
            model = document?.model
            outlineView.reloadData()
            document?.selection.afterChange.add {   change in
                let indexes = NSMutableIndexSet()
                let row = self.outlineView.row(forItem: change.newValue)
                indexes.add(row)
                assert(row != -1)
                self.outlineView.selectRowIndexes(
                    indexes as IndexSet,
                    byExtendingSelection: false
                )
                self.outlineView.scrollRowToVisible(indexes.firstIndex)
            }
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        outlineView.expandItem(nil, expandChildren: true)
    }
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? Desc {
            return item.subviews.count
        }
        if let _ = model {
            return 1
        }
        return 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? Desc {
            return item.subviews[index]
        }
        else {
            return model!
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? Desc {
            return item.subviews.count > 0
        }
        else {
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        if let item = item as? Desc {
            return "\(item.elem.name)" as AnyObject
        }
        else {
            return nil
        }
    }
    func outlineView(_ outlineView: NSOutlineView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet{
//    func outlineView(_ outlineView: NSOutlineView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        assert(proposedSelectionIndexes.count <= 1)
        let index = proposedSelectionIndexes.first!
        let item = outlineView.item(atRow: index)
        if let item = item as? Desc {
            self.document?.select(model: item)
        }
        return proposedSelectionIndexes
    }
}
