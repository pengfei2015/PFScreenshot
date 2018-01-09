//
//  ViewController.swift
//  PFScreenshot
//
//  Created by 飞流 on 2018/1/8.
//  Copyright © 2018年 飞流. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var screenshotTaken: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenshotTaken = nil
    }
    
    private func takeFullScreenshot() {
        screenshotTaken = tableView.pf.screenshot
    }
    
    private func takeScreenshotWithoutHeaders() {
        screenshotTaken = tableView.pf.screenshotIncluded(sectionHeaders: .specific([]), sectionFooters: .all, cells: .all)
    }
    
    private func takeScreenshotWithoutFooters() {
        screenshotTaken = tableView.pf.screenshotIncluded(sectionHeaders: .all, sectionFooters: .specific([]), cells: .all)
    }
    
    private func takeScreenshotForRowsOnly() {
        screenshotTaken = tableView.pf.screenshotIncluded(sectionHeaders: .specific([]), sectionFooters: .specific([]), cells: .all)
    }
    
    private func takeScreenshotForRow(at indexPath: IndexPath) {
        screenshotTaken = tableView.pf.screenshotOfCell(at: indexPath)
    }
    
    private func takeScreenshotOfVisibleContent() {
        screenshotTaken = tableView.pf.screenshotOfVisibleContent
    }
    
    private func takeScreenshotWithoutFirstHeader() {
        screenshotTaken = tableView.pf.screenshotExcluding(sectionHeaders: .specific([0]), sectionFooters: .specific([]), cells: .specific([]))
    }
    
    private func takeScreenshotOfJustLastTwoFooters() {
        let sections = tableView.numberOfSections
        screenshotTaken = tableView.pf.screenshotIncluded(sectionHeaders: .specific([]), sectionFooters: .specific([sections - 2, sections - 1]), cells: .specific([]))
    }
    
    private func takeScreenshotForJustRows(onSection section: Int) {
        let rect = tableView.rect(forSection: section)
        guard let rows = tableView.indexPathsForRows(in: rect) else { return }
        screenshotTaken = tableView.pf.screenshotIncluded(sectionHeaders: .specific([]), sectionFooters: .specific([]), cells: .specific(Set(rows)))
    }
    
    private func takeScreenshotForComplexUse() {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                takeFullScreenshot()
            case 1:
                takeScreenshotWithoutHeaders()
            case 2:
                takeScreenshotWithoutFooters()
            case 3:
                takeScreenshotForRowsOnly()
            case 4:
                takeScreenshotForRow(at: indexPath)
            case 5:
                takeScreenshotOfVisibleContent()
            default:
                print("section 0 row error")
            }
        case 1:
            switch indexPath.row {
            case 0:
                takeScreenshotWithoutFirstHeader()
            case 1:
                takeScreenshotOfJustLastTwoFooters()
            case 2:
                takeScreenshotForJustRows(onSection: indexPath.section)
            default:
                print("section 1 row error")
            }
        case 2:
            takeScreenshotForComplexUse()
        case 3:
            takeFullScreenshot()
        default:
            print("section error")
        }
        performSegue(withIdentifier: "showTableViewScreenshotSegue_Id", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableViewScreenshotSegue_Id" {
            let des = segue.destination as! ImageViewController
            des.screenshot = screenshotTaken
        }
    }
}

