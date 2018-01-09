//
//  UITableView+PFScreenshot.swift
//  PFScreenshot
//
//  Created by 飞流 on 2018/1/8.
//  Copyright © 2018年 飞流. All rights reserved.
//

import UIKit

enum SelectedType<T: Collection> {
    case all
    case specific(T)
}

extension PFSceenshot where Base: UITableView {
    
    public var screenshot: UIImage? {
        return base.pf.screenshotIncluded(sectionHeaders: .all, sectionFooters: .all, cells: .all)
    }
    
    var allSections: [Int] {
        let sections = base.numberOfSections
        return Array((0..<sections))
    }
    
    var allRowIndexPaths: [IndexPath] {
        var indexPaths: [IndexPath] = []
        allSections.forEach { section in
            let rows = base.numberOfRows(inSection: section)
            (0..<rows).forEach {
                let indexPath = IndexPath(row: $0, section: section)
                indexPaths.append(indexPath)
            }
        }
        return indexPaths
    }
    
    func screenshotIncluded(tableViewHeaderIncluded: Bool = true,
                            tableViewFooterIncluded: Bool = true,
                            sectionHeaders headerSections: SelectedType<Set<Int>>,
                            sectionFooters footerSections: SelectedType<Set<Int>>,
                            cells indexPaths: SelectedType<Set<IndexPath>>) -> UIImage? {
        var screenshots: [UIImage] = []
        if tableViewHeaderIncluded, let headerScreenshot = screenshotOfTableViewHeaderView() {
            screenshots.append(headerScreenshot)
        }
        let sections = base.numberOfSections
        (0..<sections).forEach { section in
            
            if let sectionHeaderScreenshot = screenshotOfSectionHeaderView(atSection: section, included: headerSections) {
                screenshots.append(sectionHeaderScreenshot)
            }
            let rows = base.numberOfRows(inSection: section)
            (0..<rows).forEach { row in
                let cellIndexPath = IndexPath(row: row, section: section)
                if let cellScreenshot = screenshotOfCell(at: cellIndexPath, included: indexPaths) {
                    screenshots.append(cellScreenshot)
                }
            }
            if let sectionFooterScreenshot = screenshotOfSectionFooterView(atSection: section, included: footerSections) {
                screenshots.append(sectionFooterScreenshot)
            }
        }
        if tableViewFooterIncluded, let footerViewScreenshot = screenshotOfTableViewFooterView() {
            screenshots.append(footerViewScreenshot)
        }
        return UIImage.pf.verticalImage(from: screenshots)
    }
    
    func screenshotExcluding(tableViewHeaderExcluding: Bool = true,
                            tableViewFooterExcluding: Bool = true,
                            sectionHeaders headerSections: SelectedType<Set<Int>>,
                            sectionFooters footerSections: SelectedType<Set<Int>>,
                            cells indexPaths: SelectedType<Set<IndexPath>>) -> UIImage? {
        var screenshots: [UIImage] = []
        if !tableViewHeaderExcluding, let headerScreenshot = screenshotOfTableViewHeaderView() {
            screenshots.append(headerScreenshot)
        }
        let sections = base.numberOfSections
        (0..<sections).forEach { section in
            
            if let sectionHeaderScreenshot = screenshotOfSectionHeaderView(atSection: section, excluding: headerSections) {
                screenshots.append(sectionHeaderScreenshot)
            }
            let rows = base.numberOfRows(inSection: section)
            (0..<rows).forEach { row in
                let cellIndexPath = IndexPath(row: row, section: section)
                if let cellScreenshot = screenshotOfCell(at: cellIndexPath, excluding: indexPaths) {
                    screenshots.append(cellScreenshot)
                }
            }
            if let sectionFooterScreenshot = screenshotOfSectionFooterView(atSection: section, excluding: footerSections) {
                screenshots.append(sectionFooterScreenshot)
            }
        }
        if !tableViewFooterExcluding, let footerViewScreenshot = screenshotOfTableViewFooterView() {
            screenshots.append(footerViewScreenshot)
        }
        return UIImage.pf.verticalImage(from: screenshots)
    }
    
    func screenshotOfCell(at indexPath: IndexPath, included selectedType: SelectedType<Set<IndexPath>> = .all) -> UIImage? {
        if case .specific(let indexPaths) = selectedType,
            !indexPaths.contains(indexPath) {
            return nil
        }
        let offset = base.contentOffset
        base.scrollToRow(at: indexPath, at: .top, animated: false)
        let screenshot = base.cellForRow(at: indexPath)?.pf.screenshot
        base.setContentOffset(offset, animated: false)
        return screenshot
    }
    
    func screenshotOfCell(at indexPath: IndexPath, excluding selectedType: SelectedType<Set<IndexPath>>) -> UIImage? {
        guard case .specific(let indexPaths) = selectedType,
            !indexPaths.contains(indexPath) else {
            return nil
        }
        let offset = base.contentOffset
        base.scrollToRow(at: indexPath, at: .top, animated: false)
        let screenshot = base.cellForRow(at: indexPath)?.pf.screenshot
        base.setContentOffset(offset, animated: false)
        return screenshot
    }
    
    func screenshotOfTableViewHeaderView() -> UIImage? {
        guard let headerRect = base.tableHeaderView?.frame else { return nil }
        return screenshotTableView(for: headerRect)
    }
    
    func screenshotOfTableViewFooterView() -> UIImage? {
        guard let footerRect = base.tableFooterView?.frame else { return nil }
        return screenshotTableView(for: footerRect)
    }
    
    func screenshotOfSectionHeaderView(atSection section: Int, included selectedType: SelectedType<Set<Int>> = .all) -> UIImage? {
        if case .specific(let sections) = selectedType,
            !sections.contains(section) {
            return nil
        }
        let headerRect = base.rectForHeader(inSection: section)
        return screenshotTableView(for: headerRect)
    }
    
    func screenshotOfSectionHeaderView(atSection section: Int, excluding selectedType: SelectedType<Set<Int>>) -> UIImage? {
        guard case .specific(let sections) = selectedType,
            !sections.contains(section) else {
            return nil
        }
        let headerRect = base.rectForHeader(inSection: section)
        return screenshotTableView(for: headerRect)
    }
    
    func screenshotOfSectionFooterView(atSection section: Int, included selectedType: SelectedType<Set<Int>> = .all) -> UIImage? {
        if case .specific(let sections) = selectedType,
            !sections.contains(section) {
            return nil
        }
        let footerRect = base.rectForFooter(inSection: section)
        return screenshotTableView(for: footerRect)
    }
    
    func screenshotOfSectionFooterView(atSection section: Int, excluding selectedType: SelectedType<Set<Int>>) -> UIImage? {
        guard case .specific(let sections) = selectedType,
            !sections.contains(section) else {
            return nil
        }
        let footerRect = base.rectForFooter(inSection: section)
        return screenshotTableView(for: footerRect)
    }
    private func screenshotTableView(for croppingRect: CGRect) -> UIImage? {
        let offset = base.contentOffset
        base.scrollRectToVisible(croppingRect, animated: false)
        let screenshot = base.pf.screenshot(for: croppingRect) ?? UIColor.clear.pf.toImage(size: croppingRect.size)
        base.setContentOffset(offset, animated: false)
        return screenshot
    }
}
