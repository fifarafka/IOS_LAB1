//
//  ViewController.swift
//  Przegladarka
//
//  Created by Użytkownik Gość on 13.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class SharedAlbums {
    static let sharedInstance = SharedAlbums()
    private init() {}
    
    var albums: NSMutableArray?
}


class ViewController: UIViewController {
    
    let plistCatPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist")
    
    var albums: NSMutableArray?
    
    var iterator = 0
    
    @IBOutlet weak var artist: UITextField!
    
    @IBOutlet weak var title2: UITextField!
    
    @IBOutlet weak var game: UITextField!
    
    @IBOutlet weak var year: UITextField!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var statusButton: UILabel!

    @IBOutlet weak var preview: UIButton!

    @IBOutlet weak var next: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var stepperButton: UIStepper!
    
    @IBOutlet weak var newRecord: UIButton!

    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func onStepperChange(sender: AnyObject) {
        rating.text = String(Int(stepperButton.value))
        saveButton.enabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        albums = NSMutableArray(contentsOfFile:plistCatPath!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfPreviewIsEnable()
        statusButton.text = String(iterator+1) + " z " + String((albums?.count)!)
        loadData();
        saveButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onArtistEndEditing(sender: AnyObject) {
        saveButton.enabled = true
    }
    
    @IBAction func onGenreEndEditing(sender: AnyObject) {
        saveButton.enabled = true
    }
    
    @IBAction func onTitleEndEditing(sender: AnyObject) {
        saveButton.enabled = true
    }
    
    @IBAction func onYearEndEditing(sender: AnyObject) {
        saveButton.enabled = true
    }
    
    @IBAction func onDelete(sender: AnyObject) {
        albums!.removeObjectAtIndex(iterator)
        if (albums!.count > iterator) {
            loadData()
            statusButton.text = String(iterator+1) + " z " + String((albums?.count)!)
            newRecord.enabled = true
            deleteButton.enabled = true
        } else {
            emptyForm()
            statusButton.text = "Nowy rekord"
            next.enabled = false
            newRecord.enabled = false
            deleteButton.enabled = false
        }
        checkIfPreviewIsEnable()
    }
    
    @IBAction func onNewRecord(sender: AnyObject) {
        emptyForm()
        statusButton.text = "Nowy rekord"
        iterator = albums!.count
        newRecord.enabled = false
        next.enabled = false
        preview.enabled = true
        deleteButton.enabled = false
    }

    @IBAction func onSave(sender: AnyObject) {
        if (next.enabled) {
            updateOldAlbum()
        } else {
            newAlbum()
            next.enabled = true
            deleteButton.enabled = true
        }
        saveButton.enabled = false
        newRecord.enabled = true
    }
    
    @IBAction func onPreview(sender: AnyObject) {
        iterator = iterator - 1
        checkIfPreviewIsEnable()
        loadData()
        statusButton.text = String(iterator+1) + " z " + String((albums?.count)!)
        next.enabled = true
        newRecord.enabled = true
        deleteButton.enabled = true
    }
    
    @IBAction func onNext(sender: AnyObject) {
        iterator = iterator + 1
        if (albums!.count > iterator) {
            loadData()
            statusButton.text = String(iterator+1) + " z " + String((albums?.count)!)
            newRecord.enabled = true
            deleteButton.enabled = true
        } else {
            emptyForm()
            statusButton.text = "Nowy rekord"
            next.enabled = false
            newRecord.enabled = false
            deleteButton.enabled = false
        }
        checkIfPreviewIsEnable()
    }
    
    func updateOldAlbum() {
        var optArtist: String?
        optArtist = artist.text!
        albums!.objectAtIndex(iterator).setValue(optArtist, forKey: "artist")
        var optTitle: String?
        optTitle = title2.text!
        albums!.objectAtIndex(iterator).setValue(optTitle, forKey: "title")
        var optGenre: String?
        optGenre = game.text!
        albums!.objectAtIndex(iterator).setValue(optGenre, forKey: "genre")
        var optYear: String?
        optYear = year.text!
        albums!.objectAtIndex(iterator).setValue(optYear, forKey: "date")
        var optRating: String?
        optRating = rating.text!
        albums!.objectAtIndex(iterator).setValue(optRating, forKey: "rating")
    }
    
    func newAlbum() {
        let album = NSMutableDictionary()
        album.setObject(artist.text!, forKey: "artist")
        album.setObject(game.text!, forKey: "genre")
        album.setObject(year.text!, forKey: "date")
        album.setObject(title2.text!, forKey: "title")
        album.setObject(rating.text!, forKey: "rating")
        albums!.addObject(album)
    }
    
    func checkIfPreviewIsEnable() {
        if (iterator==0) {
            preview.enabled = false
        } else {
            preview.enabled = true
        }
    }
    
    func emptyForm() {
        artist.text = nil
        title2.text = nil
        game.text = nil
        year.text = nil
        rating.text = "0"
        stepperButton.value = 0.0
    }
    
    func loadData() {
        let artistValue = albums!.objectAtIndex(iterator).objectForKey("artist")
        artist.text = "\(artistValue!)"
        let titleValue = albums!.objectAtIndex(iterator).objectForKey("title")
        title2.text = "\(titleValue!)"
        let gameValue = albums!.objectAtIndex(iterator).objectForKey("genre")
        game.text = "\(gameValue!)"
        let yearValue = albums!.objectAtIndex(iterator).objectForKey("date")
        year.text = "\(yearValue!)"
        let ratingValue = albums!.objectAtIndex(iterator).objectForKey("rating")
        rating.text = "\(ratingValue!)"
        stepperButton.value = Double(rating.text!)!
    }
}

