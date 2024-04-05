import SwiftUI

struct DashboardPage: View {
    
    @ObservedObject var pickupModel: pickupsModel
    @Binding var pageState: String
    @Binding var pickupId: Int
    
    @State var isPageLoading: Bool = false
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserLattitude: String = UserDefaults.standard.string(forKey: "LoggedUserLattitude") ?? ""
    @State private var loggedUserLongitude: String = UserDefaults.standard.string(forKey: "LoggedUserLongitude") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    func getPageData() async{
        try? await pickupModel.getNearByPickups(lattitude: loggedUserLattitude, longitude: loggedUserLongitude)
    }
    
    func acceptOrder(pickupID: Int) async{
        
        isPageLoading.toggle()
        
        try? await pickupModel.acceptOrder(pickupId: pickupID, collectorId: Int(loggedUserID)!)
        
        if(pickupModel.responseStatus == 200){
            try? await pickupModel.getNearByPickups(lattitude: loggedUserLattitude, longitude: loggedUserLongitude)
            try? await pickupModel.getAcceptedPickups(collectorID: Int(loggedUserID)!)
            try? await pickupModel.getStartedPickups(collectorID: Int(loggedUserID)!)
            try? await pickupModel.getCollectedPickups(collectorID: Int(loggedUserID)!)
            try? await pickupModel.getCompletedPickups(collectorID: Int(loggedUserID)!)
            pageState = "SuccessPage"
            isPageLoading.toggle()
        }
    }
    
    var body: some View {
        if(isPageLoading){
            LoadingPage()
        }
        else{
            VStack{
                ScrollView{
                    if(pickupModel.hasPickups){
                        ForEach(0...pickupModel.Pickups.count-1, id: \.self){i in
                            Button(action:{
                                pageState = "PickupPage"
                                pickupId = pickupModel.Pickups[i].id!
                            }){
                                VStack(spacing:15){
                                    HStack{
                                        Text("Open Request")
                                        Spacer()
                                        Text("\(pickupModel.PickupDistance[i]) Kms".capitalized)
                                    }
                                    .foregroundColor(.black)
                                    .font(.system(size: 17,weight: .medium))
                                    Divider()
                                    HStack{
                                        Image("demo")
                                            .resizable()
                                            .frame(width: 50,height: 50)
                                            .cornerRadius(5)
                                        VStack(alignment:.leading){
                                            Text("5 kgs")
                                            HStack(spacing:0){
                                                Text(pickupModel.Pickups[i].date.formatted(date: .abbreviated,time: .omitted))
                                                Text(",")
                                                    .padding(.trailing, 5)
                                                Text(pickupModel.Pickups[i].startTime.formatted(date:.omitted,time: .shortened))
                                                Text("to")
                                                    .padding(.horizontal, 5)
                                                Text(pickupModel.Pickups[i].endTime.formatted(date:.omitted,time: .shortened))
            //        //                                Spacer()
                                            }
                                        }
                                        .font(.system(size: 17,weight: .medium))
                                        Spacer()
                                    }
                                    Divider()
                                    VStack{
                                        Button(action:{
                                            let pid = pickupModel.Pickups[i].id!
                                            Task{
                                                await acceptOrder(pickupID: pid)
                                            }
                                        }){
                                            Text("Accept Order")
                                                .font(.system(size: 13, weight: .semibold))
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(Color.primaryGreen)
                                                .cornerRadius(10)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding(10)
                                .foregroundColor(.black)
                                .background(.white)
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 5)
                            }
                        }
                    }
                }
            }
            .background(Color.primaryBackground)
            .onAppear(
                perform: {
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { time in
                        Task{
                            await getPageData()
                        }
                    }
                }
            )
        }
    }
}

struct previewDashboardPage: View {
    
    @StateObject var pickupModel = pickupsModel()
    @State var pageState: String = "DashboardPage"
    @State var pickupId: Int = 0
    
    func test() async{
        try! await pickupModel.getNearByPickups(lattitude: "37.785834", longitude: "-122.406417")
    }
    
    var body: some View {
        DashboardPage(pickupModel: pickupModel, pageState: $pageState, pickupId: $pickupId)
            .task {
                do{
                    await test()
                }
                catch{
                    print(error)
                }
            }
    }
}

#Preview {
    previewDashboardPage()
}
