import Foundation
import Supabase

enum Tabel{
    
    static let Users = "Users"
    static let Pickups = "Pickups"
    static let Requests = "Requests"
    static let Collectors = "Collectors"
    
}

enum Defaults{
    
    static let profileImage = "https://firebasestorage.googleapis.com/v0/b/greenwealth-68871.appspot.com/o/Profile.png?alt=media&token=27712235-9bd0-414a-9b70-53125764e872"
    
    static let imageURL = "https://firebasestorage.googleapis.com/v0/b/greenwealth-68871.appspot.com/o/demo.png?alt=media&token=ab43aad1-9825-4e44-b78c-422a231be7cf"
    
}

final class usersModel: ObservableObject{
    
    @Published var collectors = [getCollectors]()
    @Published var usersRanking = [getCollectors]()
    @Published var userGlobalRank = 0
    @Published var responseStatus = 200
    @Published var responseMessage = "Something went wrong"
    
    @Published var isLogged = false
    
    let supabase = SupabaseClient(supabaseURL: Secrets.projectURL!, supabaseKey: Secrets.apiKey)

    func loginUser(emailAddress: String, password: String) async throws{
        
        let Collectors: [getCollectors] = try await supabase.database
            .from(Tabel.Collectors)
            .select()
            .eq("emailAddress", value: emailAddress.lowercased())
            .eq("password", value: password)
            .eq("accountStatus", value: "active")
            .order("fullName",ascending: false)
            .execute()
            .value
        DispatchQueue.main.async {
            if(!Collectors.isEmpty){
                self.isLogged = true
            }
            self.collectors = Collectors
        }
        
    }
    
    func addUser(fullName: String, emailAddress: String, mobileNumber: String, address: String, state: String, country: String, lattitude: String, longitude: String, password: String) async throws{
        
        let Collectors: [getCollectors] = try await supabase.database
            .from(Tabel.Collectors)
            .select()
            .eq("emailAddress", value: emailAddress.lowercased())
            .order("fullName",ascending: false)
            .execute()
            .value
        
        if(!Collectors.isEmpty){
            self.responseStatus = 404
            self.responseMessage = "Email already registered"
            self.isLogged = false
        }
        else{
            let newCollector = addCollectors(fullName: fullName, emailAddress: emailAddress.lowercased(), mobileNumber: mobileNumber, accountStatus: "active", deviceToken: "notYetAdded", profileImage: Defaults.profileImage, password: password, address: address+","+state+","+country, lattitude: lattitude, longitude: longitude)
            
            let response = try await supabase.database
                .from(Tabel.Collectors)
                .insert([newCollector])
                .execute()
            
            let addedCollector: [getCollectors] = try await supabase.database
                .from(Tabel.Collectors)
                .select()
                .eq("emailAddress", value: emailAddress.lowercased())
                .order("fullName",ascending: false)
                .execute()
                .value
            DispatchQueue.main.async {
                if(!addedCollector.isEmpty){
                    self.responseStatus = 200
                    self.responseMessage = "Collector created successfully"
                    self.isLogged = true
                    self.collectors = addedCollector
                }
            }
        }
        
    }
    
    func getUser(emailAddress: String) async throws{
        
        let Collectors: [getCollectors] = try await supabase.database
            .from(Tabel.Collectors)
            .select()
            .eq("emailAddress", value: emailAddress.lowercased())
            .order("fullName",ascending: false)
            .execute()
            .value
        DispatchQueue.main.async {
            
            self.responseStatus = 200
            self.responseMessage = "Found user"
            self.collectors = Collectors
        }
        
    }
    
}
