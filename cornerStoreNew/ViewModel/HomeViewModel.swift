//
//  HomeViewModel.swift
//  cornerStore
//
//  Created by Deesha Desai on 18/03/21.
//

import SwiftUI
import CoreLocation
import Firebase
// Fetching user location
class HomeViewModel: NSObject,ObservableObject, CLLocationManagerDelegate{
    @Published var locationManager = CLLocationManager()
    @Published var search=""
    
    //Llocation Details
    @Published var userLocation: CLLocation!
    @Published var userAddress =  ""
    @Published var noLocation = false
    
    //Sidebar
    @Published var showSideBar = false
    
    //ItemData
    @Published var items: [Item] = []
    @Published var filteredItems: [Item] = []
    
    //cartData
    @Published var cartItems:[Cart]=[]
    @Published var ordered = false
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //checking location acces
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("Denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
            //Direct call
            locationManager.requestWhenInUseAuthorization()
            // Modifying Info.plist
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //readding user location and extracting details
        self.userLocation = locations.last
        self.extractLocation()
        self.login()
    }
    
    func extractLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (res, err) in
            
            guard let safeData = res else{return}
            var address = ""
            //getting area and locality name...
            
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
            
            
        }
    }
    
    func login() {
        Auth.auth().signInAnonymously { (res, err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            print("Success = \(res!.user.uid)")
            
            //Get data
            self.getData()
        }
    }
    
    //fetching products
    
    func getData() {
        let db = Firestore.firestore()
        db.collection("Items").getDocuments { (snap, err) in
            
            guard let itemData = snap else {return}
            self.items = itemData.documents.compactMap({ (doc) -> Item? in
                
                let id = doc.documentID
                let name = doc.get("name") as! String
                let cost = doc.get("cost") as! NSNumber
                let ratings = doc.get("ratings") as! String
                let image = doc.get("image") as! String
                let details = doc.get("description") as! String
                
                return Item(id: id, name: name, cost: cost, description: details, image: image, ratings: ratings)
            })
            
            self.filteredItems = self.items
        }
    }
    
    //Search data
    func filterItems(){
        
        withAnimation(.linear) {
            self.filteredItems=self.items.filter{
                return $0.name.lowercased().contains(self.search.lowercased())
            }
        }
    }
    
    //add to cart
    func addToCart(item: Item) {
        
        self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        let filterIndex = self.filteredItems.firstIndex { (item1) -> Bool in
                 return item.id == item1.id
             } ?? 0
             
             self.filteredItems[filterIndex].isAdded = !item.isAdded
        if item.isAdded {
            
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
        
        self.cartItems.append(Cart(item:item, quantity:1))
    }
    
    
    func getIndex(item: Item, isCartIndex: Bool)->Int{
        let index = self.items.firstIndex{ (item1) -> Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex{ (item1) -> Bool in
            
            return item.id == item1.item.id
        } ?? 0
        return isCartIndex ? cartIndex : index
    }
    
    func calculateTotalPrice()->String{
           
           var price : Float = 0
           
           cartItems.forEach { (item) in
               price += Float(item.quantity) * Float(truncating: item.item.cost)
           }
           
           return getPrice(value: price)
       }
       
       func getPrice(value: Float)->String{
           
           let format = NumberFormatter()
           format.numberStyle = .currency
           
           return format.string(from: NSNumber(value: value)) ?? ""
       }
       
       // writing Order Data into FIrestore...
       
       func updateOrder(){
           
           let db = Firestore.firestore()
           
           // creating dict of food details...
           
           if ordered{
               
               ordered = false
               
               db.collection("Users").document(Auth.auth().currentUser!.uid).delete { (err) in
                   
                   if err != nil{
                       self.ordered = true
                   }
               }
               
               return
           }
           
           var details : [[String: Any]] = []
           
           cartItems.forEach { (cart) in
               
               details.append([
               
                "name": cart.item.name,
                   "quantity": cart.quantity,
                   "cost": cart.item.cost
               ])
           }
           
           ordered = true
           
           db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
               
               "ordered_items": details,
               "total_cost": calculateTotalPrice(),
               "location": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
               
           ]) { (err) in
               
               if err != nil{
                   self.ordered = false
                   return
               }
               print("success")
           }
       }
}




