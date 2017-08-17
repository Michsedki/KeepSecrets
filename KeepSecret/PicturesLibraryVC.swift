//
//  PicturesLibraryVC.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/13/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit
import CoreData


class PicturesLibraryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate  {
    
    // UI Outlets
    
    @IBOutlet weak var pictureTableView: UITableView!
    @IBOutlet weak var segmant: UISegmentedControl!
    
    
    
    
    // Variables
    var controller: NSFetchedResultsController<Picture>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate
        pictureTableView.delegate = self
        pictureTableView.dataSource = self
        
        
        
        attemptFetch()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        attemptFetch()
        pictureTableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditPictureDetailsVC" {
            if let des = segue.destination as? PictureDetailsVC {
                if let item = sender as? Picture {
                    des.pictureToEdit = item
                }
            }
        }
    }

    
    
    
    
    
    // implement pictureTableView protocols
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = pictureTableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! PictureCell
        configureCell(cell: cell, indexPath: indexPath)
        cell.pictureFavoritBT.tag = indexPath.row
        
        
        
        
        return cell
    }
    
    func configureCell(cell: PictureCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            
            // change value of lastusedate
            item.lastusedate = NSDate()
            ad.saveContext()
            
            performSegue(withIdentifier: "ShowEditPictureDetailsVC", sender: item)
            
        }
    }
    
    // swipe to delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let objs = controller.fetchedObjects , objs.count > 0 {
                let item = objs[indexPath.row]
                context.delete(item)
                ad.saveContext()
                
            }
            
        }
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let lastusedate = NSSortDescriptor(key: "lastusedate", ascending: false)
        let favoritSort = NSSortDescriptor(key: "isfavorit", ascending: false)
        if segmant.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [lastusedate]
        } else if segmant.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [nameSort]
        } else if segmant.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segmant.selectedSegmentIndex == 3 {
            fetchRequest.sortDescriptors = [favoritSort, nameSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pictureTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pictureTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                pictureTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                pictureTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = pictureTableView.cellForRow(at: indexPath) as! PictureCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                pictureTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                pictureTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    
    
    @IBAction func favoritBTPressed(_ sender: UIButton) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[sender.tag]
            item.isfavorit = !item.isfavorit
            ad.saveContext()
            
            
            
        }
        
        
        
        
        
    }
    
    
    @IBAction func segmantChanged(_ sender: Any) {
        attemptFetch()
        pictureTableView.reloadData()
        
    }


    
}










