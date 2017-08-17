//
//  SecretVC.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/10/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit
import CoreData


class SecretVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // UI Outlet
    
    @IBOutlet weak var secretTableView: UITableView!
    @IBOutlet weak var segmant: UISegmentedControl!
    @IBOutlet weak var navBarAddBTLB: UIBarButtonItem!
    
  
    
    
    // Variables
    var controller : NSFetchedResultsController<Secret>!
    
    var categoryToShow: Category?
    var isFavoritMode = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delsgate
        secretTableView.delegate = self
        secretTableView.dataSource = self
        
        
        
        attemptFetch()
       
        
        
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        attemptFetch()
         secretTableView.reloadData()
    }
    
    
    // implement tableView Protocol
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
        let item = objs[indexPath.row]
            
            // change value of lastusedate
            item.lastusedate = NSDate()
            ad.saveContext()
            
        performSegue(withIdentifier: "ShowEditSecretDetailVC", sender: item)
            
        }
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
        
        let cell = secretTableView.dequeueReusableCell(withIdentifier: "SecretCell", for: indexPath) as! SecretCell
        configureCell(cell: cell, indexPath: indexPath)
        cell.favoritBTLB.tag = indexPath.row
        
        
        
        
        
        
        return cell
    }
    
    func configureCell(cell: SecretCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
        
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
        
        
      
        
        let fetchRequest: NSFetchRequest<Secret> = Secret.fetchRequest()
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
        }  else if segmant.selectedSegmentIndex == 3 {
            fetchRequest.sortDescriptors = [favoritSort, nameSort]
        }
        
        if isFavoritMode  {
            segmant.isHidden = true
            navBarAddBTLB.isEnabled = false
            self.title = "Favorites"
            let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
             fetchRequest.sortDescriptors = [nameSort]
            fetchRequest.predicate = NSPredicate(format: "isfavorit = %@", (isFavoritMode as CVarArg))
            
        } else {
            
            segmant.isHidden = false
            navBarAddBTLB.isEnabled = true
            self.title = "Secrets - \((categoryToShow?.name)!)"
            
            
            fetchRequest.predicate = NSPredicate(format: "toCategory.name = %@", (categoryToShow?.name)!)
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
        secretTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        secretTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                secretTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                secretTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = secretTableView.cellForRow(at: indexPath) as! SecretCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                secretTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                secretTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditSecretDetailVC" {
            if let des = segue.destination as? SecretDetailVC {
                if let item = sender as? Secret {
                    des.secretToEdit = item
                    des.categoryToSaveIn = self.categoryToShow
                }
            }
            
        }
        
        if segue.identifier == "ShowEditSecretDetailVC" {
            if let des = segue.destination as? SecretDetailVC {
                if let item = sender as? Category {
                    des.categoryToSaveIn = item
                    
                }
            }
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    @IBAction func addNewSecretBTPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowEditSecretDetailVC", sender: categoryToShow)
    }
    
    @IBAction func favoritBTPressed(_ sender: UIButton) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[sender.tag]
            item.isfavorit = !item.isfavorit
            ad.saveContext()
        
        
        
        }
        
        
    }
    
    
    
    @IBAction func segmantChanged(_ sender: UISegmentedControl) {
        
        attemptFetch()
        secretTableView.reloadData()
        
    }
   
    

}
