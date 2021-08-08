//
//  ViewController.swift
//  ProbCalc
//
//  Created by AbdulWahab Fanar on 8/7/21.
//  Copyright © 2021 AbdulWahab Fanar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    
    @IBOutlet weak var nTextField: UITextField!
    
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var rTextField: UITextField!
    @IBOutlet weak var calcButton: UIButton!
    @IBOutlet weak var modeSegment: UISegmentedControl!
    @IBOutlet weak var historyTableView: UITableView!
    
    enum calcType {
        case Combination
        case Premutation
    }
    
    var currentCalcType: calcType = .Combination
    var resultsArray: [String] = []
    
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        nTextField.text = ""
        rTextField.text = ""
        resultsArray = []
        refreshTable()
    }
    
    fileprivate func setupViews() {
        nTextField.delegate = self
        rTextField.delegate = self
        
        calcButton.layer.cornerRadius = 9
        calcButton.clipsToBounds = true
        
        modeSegment.setTitle("Combination", forSegmentAt: 0)
        modeSegment.setTitle("Premutation", forSegmentAt: 1)
        
        historyTableView.layer.cornerRadius = 10
        historyTableView.clipsToBounds = true
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CID")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        refreshTable()
    }
    
    
    @IBAction func handleBarButtonTapped(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/wh0ba/")!)
    }
    @IBAction func tapRecognized(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func refreshTable() {
        historyTableView.reloadData()
        if historyTableView.numberOfRows(inSection: 0) <= 0{
            let label: UILabel = {
                let lbl = UILabel(frame: historyTableView.backgroundView?.frame ?? CGRect.zero)
                lbl.text = "History"
                lbl.textColor = UIColor.init(white: 0.5, alpha: 0.7)
                lbl.textAlignment = .center
                lbl.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
                return lbl
            }()
            historyTableView.backgroundView = label
            historyTableView.separatorStyle = .none
        }else {
            if (historyTableView.backgroundView?.isKind(of: UILabel.self))! {
                historyTableView.backgroundView = UIView()
                historyTableView.separatorStyle = .singleLine
            }
        }
    }
    
    func setupNavBar() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
    }
    
    @IBAction func calcButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let n = Int(nTextField.text!) else { return }
        guard let r = Int(rTextField.text!) else { return }
        
        let result: String
        if (currentCalcType == .Combination){
            result = "\(n)C\(r) = \(combination(n: n, r: r))"
        }else {
            result = "\(n)P\(r) = \(premutation(n: n, r: r))"
        }
        
        resultsArray.insert(result, at: 0)
        
        refreshTable()
        nTextField.text = ""
        rTextField.text = ""
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setCalcType(.Combination)
        case 1:
            setCalcType(.Premutation)
        default:
            setCalcType(.Combination)
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowrdCharchters = CharacterSet.decimalDigits
        return allowrdCharchters.isSuperset(of: CharacterSet(charactersIn: string))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CID")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "CID")
        }
        cell?.backgroundColor = .clear
        return cell!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = resultsArray[indexPath.row]
    }
    
    func setCalcType(_ type: calcType)  {
        currentCalcType = type
        if type == .Combination {
            modeLabel.text = "C"
        }else {
            modeLabel.text = "P"
        }
    }
    
    func factorail(_ n:Int) -> Float {
        if (n == 0) {
            return 1
        }
        else {
            return Float(n) * factorail(n-1) as Float
        }
    }
    func combination(n: Int, r: Int) -> Float {
        let c = factorail(n) / (factorail(r) * factorail(n - r))
        
        return c
    }
    func premutation(n: Int, r: Int) -> Float {
        let p = factorail(n) / factorail(n - r)
        return p
    }
    
    
}

