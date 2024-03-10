
import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var customPctButton: UIButton!
    @IBOutlet weak var customPctInput: UITextField!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    
    var tip = 0.10
    var numberOfPeople = 2
    var billTotal = 0.0
    var finalResult = "0.0"
    let color = (green: #colorLiteral(red: 0.006506380159, green: 0.6276578307, blue: 0.3824772537, alpha: 1), white: #colorLiteral(red: 0.7672854066, green: 0.8901608586, blue: 0.8400463462, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customPctInput.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @IBAction func tipChanged(_ sender: UIButton) {
        
        billTextField.endEditing(true)
        
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        customPctButton.isSelected = false
        customPctInput.backgroundColor = .clear
        customPctInput.textColor = color.green
        
        sender.isSelected = true
        
        if customPctButton.isSelected || customPctInput.isSelected {
            customPctInput.becomeFirstResponder()
            customPctInput.backgroundColor = color.green
            customPctInput.textColor = color.white
        } else {
            view.endEditing(true)
            calculate(sender: sender.currentTitle!)
        }
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        splitNumberLabel.text = String(format: "%.0f", sender.value)
        numberOfPeople = Int(sender.value)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let bill = billTextField.text!
        if bill != "" {
            billTotal = Double(bill)!
            if customPctButton.isSelected {
                let customValue = customPctInput.text! + "%"
                customPctButton.setTitle(customValue, for: .normal)
                calculate(sender: customValue)
            }
            let result = billTotal * (1 + tip) / Double(numberOfPeople)
            finalResult = String(format: "%.2f", result)
        }
        self.performSegue(withIdentifier: "goToResults", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToResults" {
            
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.result = finalResult
            destinationVC.tip = Int(tip * 100)
            destinationVC.split = numberOfPeople
        }
    }
    
    func calculate(sender: String) {
        let buttonTitle = sender
        let buttonTitleMinusPercentSign = String(buttonTitle.dropLast())
        let buttonTitleAsANumber = Double(buttonTitleMinusPercentSign)!
        tip = buttonTitleAsANumber / 100
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        customPctInput.endEditing(true)
        return true
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
