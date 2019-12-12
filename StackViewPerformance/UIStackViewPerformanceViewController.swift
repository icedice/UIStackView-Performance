
import UIKit

class UIStackViewPerformanceViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var numberOfViewsToSpawn = 1
    var start       : CFAbsoluteTime?
    var main        : MainController?
    var layoutMethod: LayoutMethod!
    var advancedView: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start = CFAbsoluteTimeGetCurrent()
        self.navigationController?.isNavigationBarHidden = false
        
        switch layoutMethod {
            case .UIStackView:
                layoutUsingUIStackView()
            case .AutoLayout:
                layoutUsingAutoLayout()
            case .ManualLayout:
                layoutManually()
            case .none:
                break
            }
    }
    
    class john: UIView{
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            return CGSize(width: 200,height: 200)
        }
    }
    
     override func viewDidAppear(_ animated: Bool) {
      //  _ = navigationController?.popViewController(animated: false)
     }
    
    override func viewDidLayoutSubviews() {
        let diff = CFAbsoluteTimeGetCurrent() - start!
        let delta = Double(round(1000*diff)/1000)
        main?.time = String(delta) + "s"
    }
    
    func layoutUsingUIStackView(){
        let stack = UIStackView(frame: .zero)
           stack.alignment    = .fill
           stack.distribution = .equalSpacing
           stack.axis         = .vertical
           stack.spacing      = 10
           stack.fillContainerView(container: scrollView)
           
           for _ in 1...numberOfViewsToSpawn{
                let spawnView = getSpawnView()
        
               stack.addArrangedSubview(spawnView)
           }
    }
    
    func layoutUsingAutoLayout(){
        let containerView = UIView(frame: .zero)
        containerView.fillContainerView(container: scrollView)
        
        var previousSibling: UIView?
   
       for _ in 1...numberOfViewsToSpawn{
            let spawnView = getSpawnView()
           spawnView.translatesAutoresizingMaskIntoConstraints = false
           containerView.addSubview(spawnView)
           spawnView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
           spawnView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        if let prev = previousSibling{
           spawnView.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: 20).isActive = true
        } else{
            spawnView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        }
        
        previousSibling = spawnView
        }
    }
    
     func layoutManually(){
        let containerView = UIView(frame: scrollView.bounds)
        containerView.clipsToBounds = true
        
        containerView.autoresizesSubviews = false

        scrollView.addSubview(containerView)

        var previousSibling: UIView?

        for _ in 1...numberOfViewsToSpawn{
            let spawnView = getSpawnView()
            
            if let prev = previousSibling{
                spawnView.frame = CGRect(x: 0, y: prev.frame.maxY, width: containerView.frame.width, height: 50)
           } else{
                spawnView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: 50)
           }

            previousSibling = spawnView
            containerView.addSubview(spawnView)
         }

        containerView.resizeToFitSubviews()
        scrollView.contentSize = containerView.frame.size
     }
    
    func getSpawnView() -> UIView{
        if(advancedView){
            return Bundle(for: UIStackViewPerformanceViewController.self).loadNibNamed(String("SpawnView"), owner: nil, options: nil)![0] as! UIView
        }
        let simpleView = UILabel(frame: .zero)
        simpleView.text = "TEST"
        simpleView.sizeToFit()
        return simpleView
    }
}

extension UIView{
    func fillContainerView(container: UIView){
        self.translatesAutoresizingMaskIntoConstraints                         = false
        container.addSubview(self)
        self.topAnchor.constraint(equalTo: container.topAnchor).isActive       = true
        self.rightAnchor.constraint(equalTo: container.rightAnchor).isActive   = true
        self.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: container.leftAnchor).isActive     = true
    }
}

extension UIView {

    /// Extension, resizes this view so it fits the largest subview
    func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            let newWidth = aView.frame.origin.x + aView.frame.width
            let newHeight = aView.frame.origin.y + aView.frame.height
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
    }
}
