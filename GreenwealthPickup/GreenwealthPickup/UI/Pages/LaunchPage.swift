import SwiftUI

struct LaunchPage: View {
    
    @ObservedObject var userModel: usersModel
    @ObservedObject var pickupModel: pickupsModel
    @ObservedObject var pickUp: pickUp
    @Binding var pageState: String
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserLattitude: String = UserDefaults.standard.string(forKey: "LoggedUserLattitude") ?? ""
    @State private var loggedUserLongitude: String = UserDefaults.standard.string(forKey: "LoggedUserLongitude") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    @StateObject var locationManager = LocationManager()
    
    func homeSwitch() async{
        if(isLogged){
            try? await userModel.getUser(emailAddress: loggedUserEmail)
            try? await pickupModel.getNearByPickups(lattitude: loggedUserLattitude, longitude: loggedUserLongitude)
            try? await pickupModel.getAcceptedPickups(collectorID: Int(loggedUserID)!)
            try? await pickupModel.getStartedPickups(collectorID: Int(loggedUserID)!)
            try? await pickupModel.getCollectedPickups(collectorID: Int(loggedUserID)!)
            try? await pickupModel.getCompletedPickups(collectorID: Int(loggedUserID)!)
            withAnimation{
                pageState = "DashboardPage"
            }
        }
        else{
            try? await Task.sleep(nanoseconds: 1_000_000_000)
                withAnimation{
                    pageState = "SigninPage"
                }
        }
    }
    
    var body: some View {
        ZStack{
            VStack(spacing:250){
                VStack{
                    Image(systemName: "arrow.3.trianglepath")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(Color.primaryGreen)
                        .font(.system(size: 60,weight: .black))
                    Text("Greenwealth")
                        .font(.system(size: 32,weight: .bold))
                }
                VStack{
                    Text("Sell your old goods in 4 simple steps.")
                        .font(.system(size: 17,weight: .regular))
                    Text("Earn money and eco–points.")
                        .font(.system(size: 17,weight: .regular))
                }
            }
        }
        .task {
            await homeSwitch()
        }
//        .transition(.move(edge: .bottom))
        .animation(.easeInOut(duration: 0.5))
    }
}

struct previewLaunchPage: View {
    
    @State var pageState: String = "LaunchPage"
    @StateObject private var userModel = usersModel()
    @StateObject private var pickupModel = pickupsModel()
    @StateObject var pickupData = pickUp()
    
    var body: some View {
        LaunchPage(userModel: userModel, pickupModel: pickupModel, pickUp: pickupData, pageState: $pageState)
    }
}

#Preview {
    previewLaunchPage()
}
