import Foundation
import Supabase
import CoreLocation

final class pickupsModel: ObservableObject{
    
    @Published var responseStatus = 404
    @Published var responseMessage = "Something went wrong"
    
    @Published var hasActivePickups = false
    @Published var activePickups = [getPickUp]()
    
    @Published var hasPickups = false
    @Published var Pickups = [getPickUp]()
    @Published var PickupDistance: [Int] = []
    
    @Published var hasAcceptedPickups: Bool = false
    @Published var acceptedPickups = [getPickUp]()
    
    @Published var hasStartedPickups: Bool = false
    @Published var startedPickups = [getPickUp]()
    
    @Published var hasCollectedPickups: Bool = false
    @Published var collectedPickups = [getPickUp]()
    
    @Published var currentPickup = [getPickUp]()
    
    @Published var currentUser = [getUsers]()
    
    let supabase = SupabaseClient(supabaseURL: Secrets.projectURL!, supabaseKey: Secrets.apiKey)
    
    func getNearByPickups(lattitude: String, longitude: String) async throws{
        
        let Pickups: [getPickUp] = try await supabase.database
            .from(Tabel.Pickups)
            .select()
            .eq("status", value: "booked")
            .execute()
            .value
        DispatchQueue.main.sync {
            if(Pickups.isEmpty){
                self.hasPickups = false
                self.responseStatus = 201
                self.responseMessage = "No pickups found"
            }
            else{
                let latitudeMain = Double((lattitude as NSString).doubleValue)
                let longitudeMain = Double((longitude as NSString).doubleValue)
                let coordinateOne = CLLocation(latitude: latitudeMain, longitude: longitudeMain)
                for i in 0...Pickups.count-1{
                    let latitudeSub = Double((Pickups[i].lattitude as NSString).doubleValue)
                    let longitudeSub = Double((Pickups[i].longitude as NSString).doubleValue)
                    let coordinateTwo = CLLocation(latitude: latitudeSub, longitude: longitudeSub)
                    
                    let distanceInMeters = coordinateOne.distance(from: coordinateTwo)
                    
                    if(distanceInMeters < 20000){
                        if(!self.Pickups.contains(Pickups[i])){
                            self.hasPickups = true
                            self.Pickups.append(Pickups[i])
                            self.PickupDistance.append(Int(distanceInMeters/1000))
                        }
                    }
                }
            }
        }
    }
    
    func getPickupInfo(pickupId: Int) async throws{
        print(pickupId)
        self.currentPickup = []
        
        let Pickups: [getPickUp] = try await supabase.database
            .from(Tabel.Pickups)
            .select()
            .eq("id", value: pickupId)
            .execute()
            .value
        DispatchQueue.main.sync {
            if(Pickups.isEmpty){
                self.responseStatus = 201
                self.responseMessage = "No pickups found"
            }
            else{
                self.responseStatus = 200
                self.responseMessage = "Pickups found"
            }
            self.currentPickup = Pickups
        }
    }
    
    func acceptOrder(pickupId: Int, collectorId: Int) async throws{
        try await supabase.database
            .from(Tabel.Pickups)
            .update(["collectorId":collectorId])
            .eq("id", value: pickupId)
            .execute()
        try await supabase.database
            .from(Tabel.Pickups)
            .update(["status":"accepted"])
            .eq("id", value: pickupId)
            .execute()
        self.responseStatus = 200
        self.responseMessage = "Order Accepted"
    }
    
    func startOrder(pickupId: Int) async throws{
        try await supabase.database
            .from(Tabel.Pickups)
            .update(["status":"started"])
            .eq("id", value: pickupId)
            .execute()
        self.responseStatus = 200
        self.responseMessage = "Order Started"
    }
    
    func getuser(userId: Int) async throws{
        
        self.currentUser = []
        
        let Users: [getUsers] = try await supabase.database
            .from(Tabel.Users)
            .select()
            .eq("id", value: userId)
            .execute()
            .value
        DispatchQueue.main.sync {
            if(Users.isEmpty){
                self.responseStatus = 201
                self.responseMessage = "No pickups found"
            }
            else{
                self.responseStatus = 200
                self.responseMessage = "Pickups found"
            }
            self.currentUser = Users
        }
        
    }
    
    func completeOrder(pickupId: Int, finalPrice: String, userId: Int) async throws{
        try await supabase.database
            .from(Tabel.Pickups)
            .update(["finalPrice":Double(finalPrice)!])
            .eq("id", value: pickupId)
            .execute()
        try await supabase.database
            .from(Tabel.Pickups)
            .update(["status":"collected"])
            .eq("id", value: pickupId)
            .execute()
        try await supabase.database
            .from(Tabel.Users)
            .update(["totalAmount": currentUser[0].totalAmount!+Float(finalPrice)!])
            .eq("id", value: userId)
            .execute()
        try await supabase.database
            .from(Tabel.Users)
            .update(["ecoPoints": currentUser[0].ecoPoints!+Int(2*Double(finalPrice)!)])
            .eq("id", value: userId)
            .execute()
        self.responseStatus = 200
        self.responseMessage = "Order Collected"
    }
    
    func getAcceptedPickups(collectorID: Int) async throws{
        
        self.acceptedPickups = []
        
        let Pickups: [getPickUp] = try await supabase.database
            .from(Tabel.Pickups)
            .select()
            .eq("collectorId", value: collectorID)
            .eq("status", value: "accepted")
            .execute()
            .value
        DispatchQueue.main.sync {
            if(Pickups.isEmpty){
                self.hasAcceptedPickups = false
                self.responseStatus = 201
                self.responseMessage = "No pickups found"
            }
            else{
                self.hasAcceptedPickups = true
                self.responseStatus = 200
                self.responseMessage = "Pickups found"
            }
            self.acceptedPickups = Pickups
        }
        
    }
    
    func getStartedPickups(collectorID: Int) async throws{
        
        self.startedPickups = []
        
        let Pickups: [getPickUp] = try await supabase.database
            .from(Tabel.Pickups)
            .select()
            .eq("collectorId", value: collectorID)
            .eq("status", value: "started")
            .execute()
            .value
        DispatchQueue.main.sync {
            if(Pickups.isEmpty){
                self.hasStartedPickups = false
                self.responseStatus = 201
                self.responseMessage = "No pickups found"
            }
            else{
                self.hasStartedPickups = true
                self.responseStatus = 200
                self.responseMessage = "Pickups found"
            }
            self.startedPickups = Pickups
        }
        
    }
    
    func getCollectedPickups(collectorID: Int) async throws{
        
        self.collectedPickups = []
        
        let Pickups: [getPickUp] = try await supabase.database
            .from(Tabel.Pickups)
            .select()
            .eq("collectorId", value: collectorID)
            .eq("status", value: "collected")
            .execute()
            .value
        DispatchQueue.main.sync {
            if(Pickups.isEmpty){
                self.hasCollectedPickups = false
                self.responseStatus = 201
                self.responseMessage = "No pickups found"
            }
            else{
                self.hasCollectedPickups = true
                self.responseStatus = 200
                self.responseMessage = "Pickups found"
            }
            self.collectedPickups = Pickups
        }
        
    }
    
    func getCompletedPickups(collectorID: Int) async throws{
        let Pickups: [getPickUp] = try await supabase.database
            .from(Tabel.Pickups)
            .select()
            .eq("collectorId", value: collectorID)
            .eq("status", value: "completed")
            .execute()
            .value
        DispatchQueue.main.sync {
            if(Pickups.isEmpty){
                self.hasCollectedPickups = false
                self.responseStatus = 201
                self.responseMessage = "No pickups found"
            }
            else{
                self.hasCollectedPickups = true
                self.responseStatus = 200
                self.responseMessage = "Pickups found"
            }
            self.collectedPickups += Pickups
        }
    }
    
}
