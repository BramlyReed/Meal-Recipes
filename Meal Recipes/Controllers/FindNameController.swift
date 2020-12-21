//
//  FindNameController.swift
//  Meal Recipes
//
//  Created by Stas on 07.12.2020.
//

import UIKit

class FindNameController: UIViewController, MyTableViewCellDelegate {

    //MARK: Make sure that you don't use a hardwarekeybord. Only device's keybord, because searchButton is located in keybord.
    var aView: UIView?
    var meals: [Meal] = []
    var mealNames: [String] = []
    var mealId: [String] = []
    @IBOutlet weak var tableWithNames: UITableView!
    @IBOutlet weak var searchString: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableWithNames.dataSource = self
        tableWithNames.delegate = self
        searchString.delegate = self
        tableWithNames.isHidden = false
        searchString.layer.cornerRadius = 15.0
        searchString.layer.borderWidth = 0.5
    }
    
    // MARK: To hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  touches.first != nil{
                view.endEditing(true)
            }
            super.touchesBegan(touches, with: event)
        }
    // MARK: Seaching recipes with name from seacrhString
    func findnames(){
        if searchString.text != ""{
            self.meals = []
            self.mealNames = []
            self.mealId = []
            //if we got Emoji or whitespaces - remove it
            var tmpString = searchString.text!.components(separatedBy: CharacterSet.symbols).joined()
            tmpString = tmpString.trimmingCharacters(in: .whitespacesAndNewlines)

            var customURL = "https://www.themealdb.com/api/json/v1/1/search.php?s="
            customURL += tmpString
            //if whitespaces or something else weren't removed show allert
            guard let readyURL = URL(string: customURL) else{
                showAlertErrorAnother()
                return
            }
            self.showSpinner()
            URLSession.shared.dataTask(with: readyURL, completionHandler: { data, response, error in
                guard let data = data, error == nil else{
                    print("Some error got after request!")
                    self.removeSpinner()
                    return
                }
                // if we got nil result - {"meals":null} or no data
                var resultmeal: Mealdata
                if (data.count == 14 || data.count == 0){
                    DispatchQueue.main.async {
                        self.mealNames.append("Nothing found")
                        self.tableWithNames.reloadData()
                    }
                }
                else{
                    let decoder = JSONDecoder()
                    resultmeal = try! decoder.decode(Mealdata.self, from: data)
                    DispatchQueue.main.async {
                        for item in resultmeal.meals{
                            self.meals.append(item)
                            self.mealId.append(self.meals.last!.id)
                            self.mealNames.append(self.meals.last!.name)
                        }
                        self.tableWithNames.reloadData()
                    }
                }
            }).resume()
            self.removeSpinner()
        }
    }
    
    // MARK: show RandomController with choosen recipe's cell
    func showFoundNames(){
        guard let VC = storyboard?.instantiateViewController(identifier: "showController") as? RandomController else { return }
        VC.modalTransitionStyle = .flipHorizontal
        present(VC,animated: true)
    }
}
extension FindNameController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mealNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableWithNames.isHidden = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableCell
        cell.settext(name: mealNames[indexPath.item])
        cell.delegate = self
        return cell
    }
}
extension FindNameController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableWithNames.cellForRow(at: indexPath) as! TableCell
        if self.mealNames[indexPath.row] != "Nothing found"{
            //saving recipe's id in UserDefaults
            var tmpId = mealId[indexPath.row]
            UserDefaults.standard.setValue(tmpId, forKey: "SavedId")
            showFoundNames()
        }
    }
}
extension FindNameController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchString.text!.count != 0{
            findnames()
        }
        return true
    }
}

// MARK: extension: alerts and spinner for RandomController
extension FindNameController {
    func showAlertErrorAnother() {
        let alert = UIAlertController(title: "Error!", message: "Try again with another search string", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
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

