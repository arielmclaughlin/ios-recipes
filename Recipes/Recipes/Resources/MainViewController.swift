import UIKit

class MainViewController: UIViewController {
    
    let networkClient = RecipesNetworkClient()
    
    var allRecipes:[Recipe] = [] {
        didSet {
            filterRecipes()
        }
    }
    
    var filterdRecipes: [Recipe] = [] {
        didSet {
            recipesTableViewController?.recipes = filterdRecipes
        }
    }
    
    func filterRecipes() {
        DispatchQueue.main.async {
            guard let search = self.searchTextField.text else {return}
            
            if search == "" {
                self.filterdRecipes = self.allRecipes
            }else{
                self.filterdRecipes = self.allRecipes.filter {$0.name.contains(search) || $0.instructions.contains(search)}
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkClient.fetchRecipes { (recipes, error) in
            
            if let error = error {
                NSLog("error getting recipes: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.allRecipes = recipes ?? []
            }
            
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func DidEndonExit(_ sender: Any) {
        resignFirstResponder()
        filterRecipes()
    }
    
    var recipesTableViewController: RecipesTableViewController! {
        didSet{
            recipesTableViewController?.recipes = filterdRecipes
        }
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeSegue" {
            recipesTableViewController = (segue.destination as! RecipesTableViewController)
            
        }
    }
}
