//
//  RandomController.swift
//  Recipes
//
//  Created by Stas on 04.12.2020.
//

import UIKit
import RealmSwift

protocol MyCustomAllerts: AnyObject{
    func showcustomAlert(tmp: String, message: String)
}

class RandomController: UIViewController, MyCustomAllerts {
    var aView: UIView?
    var storedID: String?
    var storedURL: String?
    var meals: Meal?
    var textButtonChanger = true
    
    @IBOutlet weak var multyButton: UIButton!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var ingredienstLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealName.isHidden = true
        imagePlace.isHidden = true
        ingredienstLabel.isHidden = true
        instructionsLabel.isHidden = true
        imagePlace.layer.cornerRadius = 15.0
        imagePlace.layer.borderWidth = 1.0
        multyButton.isHidden = true
        
        // MARK: get recipe's id from UserDefaults
        
        let name = UserDefaults.standard.string(forKey: "SavedId") ?? "Unknown"
        //if were some actions from FindNameController
        if name != "Unknown"{
            self.randomButton.isHidden = true
            let tmp = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=" + name
            UserDefaults.standard.removeObject(forKey: "SavedId")
            getRecepi(gURL: tmp)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateMultyButton), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    @IBAction func getRandomRecipe(_ sender: Any) {
        getRecepi(gURL: "https://www.themealdb.com/api/json/v1/1/random.php")
    }
    
    // MARK: Save or Delete data
    
    @IBAction func SaveOrDeleteButton(_ sender: Any) {
        let realm = try! Realm()
        let tmpObject = SavedMeal(id: self.storedID!, name: self.mealName.text!, imageURL: self.storedURL!, ingredients: self.ingredienstLabel.text!, instructions: self.instructionsLabel.text!)
        if multyButton.titleLabel!.text == "Save"{
            let uniqueAmount = realm.objects(SavedMeal.self).filter("id = %@", self.storedID as Any)
            if uniqueAmount.count == 0{
                try! realm.write{
                    realm.add(tmpObject)
                }
                showcustomAlert(tmp: "Completed!", message: "This recipe was saved.")
            }
            else{
                showcustomAlert(tmp: "Error!", message: "This recipe was already saved.")
            }
        }
        else{
            let object = realm.objects(SavedMeal.self).filter("id = %@", self.storedID as Any).first
            try! realm.write {
                if let obj = object{
                    realm.delete(obj)
                }
            }
            showcustomAlert(tmp: "Deleted!", message: "This recipe was deleted.")
        }
        textButtonChanger.toggle()
        if !(textButtonChanger){
            multyButton.setTitle("Delete", for: .normal)
            multyButton.setTitleColor(.red, for: .normal)
        }
        else{
            multyButton.setTitle("Save", for: .normal)
            multyButton.setTitleColor(.link, for: .normal)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    // MARK: get random / recipe with name
    
    func getRecepi(gURL: String) {
        self.showSpinner()
        let url = gURL
        API.randomReq(to_url: url) { mealll in
            if mealll != nil{
                
                self.meals = mealll.meals.last
                self.storedID = self.meals?.id
                self.storedURL = self.meals?.imageURLString
                self.mealName.text = self.meals?.name
                
                // MARK: get image of recipe
                
                let tmp_photomodel = mealll.meals.last?.imageURLString
                API.getPhoto(photomodel: tmp_photomodel!) {
                    gotPhoto in
                    if gotPhoto != nil {
                        DispatchQueue.main.async {
                            self.imagePlace.image = gotPhoto
                        }
                    }
                }
                // MARK: show ingredients and instructions, remove spinner
                self.mealName.isHidden = false
                self.imagePlace.isHidden = false
                self.ingredienstLabel.text = ("INGREDIENTS:")
                self.ingredienstLabel.text? += "\(self.meals!.ingredients)"
                self.instructionsLabel.text? = "INSTRUCTIONS:"
                self.instructionsLabel.text? += "\n\(self.meals!.instructions)"
                self.ingredienstLabel.isHidden = false
                self.instructionsLabel.isHidden = false
                self.removeSpinner()
            }
        }
        multyButton.setTitle("Save", for: .normal)
        multyButton.setTitleColor(.link, for: .normal)
        textButtonChanger = true
        multyButton.isHidden = false
    }
    @objc func updateMultyButton(){
        if multyButton.titleLabel?.text == "Delete"{
            multyButton.setTitle("Save", for: .normal)
            multyButton.setTitleColor(.link, for: .normal)
        }
        else{
            multyButton.setTitle("Delete", for: .normal)
            multyButton.setTitleColor(.red, for: .normal)
        }
        textButtonChanger.toggle()
    }
    
    func showcustomAlert(tmp: String, message: String) {
        let alert = UIAlertController(title: tmp, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
// MARK: extension spinner for RandomController
extension RandomController {
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
}

