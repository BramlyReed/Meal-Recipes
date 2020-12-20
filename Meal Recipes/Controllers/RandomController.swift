//
//  RandomController.swift
//  Recipes
//
//  Created by Stas on 04.12.2020.
//

import UIKit
import RealmSwift
class RandomController: UIViewController {

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
        imagePlace.layer.cornerRadius = 15.0
        imagePlace.layer.borderWidth = 1.0
        multyButton.isHidden = true
        // MARK: get recipe's id from UserDefaults
        
        var name = UserDefaults.standard.string(forKey: "SavedId") ?? "Unknown"
        //if were some actions from FindNameController
        if name != "Unknown"{
            self.randomButton.isHidden = true
            var tmp = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=" + name
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
        let basa = realm.objects(SavedMeal.self)
        var tmpObject = SavedMeal(id: self.storedID!, name: self.mealName.text!, imageURL: self.storedURL!, ingredients: self.ingredienstLabel.text!, instructions: self.instructionsLabel.text!)
        if multyButton.titleLabel!.text == "Save"{
            let uniqueAmount = realm.objects(SavedMeal.self).filter("id = %@", self.storedID)
            if uniqueAmount.count == 0{
                try! realm.write{
                    realm.add(tmpObject)
                }
                print("SAVED")
                print(basa.last!.name)
            }
            else{print("NOT UNIQUE")}
        }
        else{
            let object = realm.objects(SavedMeal.self).filter("id = %@", self.storedID).first
            try! realm.write {
                if let obj = object{
                    realm.delete(obj)
                }
            }
            print("DELETE")
            print(basa.count)
        }
        textButtonChanger.toggle()
        print(textButtonChanger)
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
    
    // MARK: get random / withname recipe
    
    func getRecepi(gURL: String) {
        let url = gURL
        API.randomReq(to_url: url) { mealll in
            if mealll != nil{
                
                self.meals = mealll.meals.last!
                self.storedID = self.meals!.id
                self.storedURL = self.meals!.imageURLString
                self.mealName.text = self.meals!.name
                
                // MARK: get image of recipe
                
                let tmp_photomodel = mealll.meals.last!.imageURLString
                API.getPhoto(photomodel: tmp_photomodel) {
                    gotPhoto in
                    if gotPhoto != nil {
                        DispatchQueue.main.async {
                            self.imagePlace.image = gotPhoto
                        }
                    }
                }
                // MARK: show ingredients and instructions
                
                self.ingredienstLabel.text = "INGREDIENTS:"
                self.ingredienstLabel.text! += self.meals!.ingredients
                self.instructionsLabel.text = "INSTRUCTIONS:"
                self.instructionsLabel.text! += "\n\(self.meals!.instructions)"
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
}

