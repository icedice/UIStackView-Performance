import UIKit

class MainController: UIViewController {
    @IBOutlet weak var numViewsSlider: UISlider!
    @IBOutlet weak var numViewsLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var layoutMethodSegment: UISegmentedControl!
    @IBOutlet weak var advancedSpawnViewSwitch: UISwitch!
    
    var time: String?{
        didSet{
            timerLbl.text = time
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutMethodSegment.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)], for: .normal)
        self.navigationController?.isNavigationBarHidden = true
        numViewsLbl.text = String(Int(numViewsSlider.value))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! UIStackViewPerformanceViewController
        let numViews = Int(numViewsSlider.value)
        dest.main = self
        dest.layoutMethod = LayoutMethod(rawValue: layoutMethodSegment.selectedSegmentIndex)
        dest.numberOfViewsToSpawn = numViews
        dest.advancedView = advancedSpawnViewSwitch.isOn
    }

    @IBAction func sliderChangedVal(_ sender: Any) {
        numViewsLbl.text = String(Int(numViewsSlider.value))
    }
 
}

enum LayoutMethod: Int{
    case UIStackView, AutoLayout, ManualLayout
}
