import SwiftUI
import MapKit

struct SignupPage: View {
    
    @ObservedObject var userModel: usersModel
    @ObservedObject var pickupModel: pickupsModel
    @Binding var pageState: String
    @Binding var previousPageState: String
    
    @State var fullName: String = ""
    @State var userName: String = ""
    @State var mobileNumber: String = ""
    @State var passWord: String = ""
    @State var isPasswordVissible: Bool = false
    @State private var lattitude: String = ""
    @State private var longitude: String = ""
    @State private var address: String = ""
    @State private var state: String = ""
    @State private var country: String = ""
    
    @State var formErrors: [String] = ["","","",""]
    
    @State var isToastPresented: Bool = false
    @State var toastMessage: String = ""
    
    @State var isPageLoading: Bool = false
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                address = "Failed to retrieve address"
            }
            if let placemarks = placemarks, let placemark = placemarks.first {
                address = String(placemark.name ?? "")
                state = String(placemark.locality ?? "")
                country = String(placemark.country ?? "")
                
            }
            else{
                address = "Failed to retrieve address"
            }
        })
    }
    
    @StateObject var locationManager = LocationManager()
    @State private var position = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    func useMyLocation(){

        var userLatitude = locationManager.lastLocation?.coordinate.latitude ?? 37.785834
        var userLongitude = locationManager.lastLocation?.coordinate.longitude ?? -122.406417
        
        lattitude = String(userLatitude)
        longitude = String(userLongitude)
        
        position = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        reverseGeocoding(latitude: userLatitude, longitude: userLongitude)
    }
    
    func formValidation()->Bool{
        
        var isFormValid: Bool = true
        
        if(fullName == ""){
            isFormValid = false
            formErrors[0] = "Name is required"
        }
        
        if(userName == ""){
            isFormValid = false
            formErrors[1] = "Email ID is required"
        }
        else if( !userName.contains("@") || !userName.contains(".com")){
            isFormValid = false
            formErrors[1] = "Enter a valid Email ID"
        }
        
        if(mobileNumber == ""){
            isFormValid = false
            formErrors[2] = "Mobile Number is required"
        }
        else if((Int(mobileNumber) ?? 1)/1000000000<1 || (Int(mobileNumber) ?? 1)/1000000000>10){
            isFormValid = false
            formErrors[2] = "Enter a valid Mobile Number"
        }
        
        if(passWord == ""){
            isFormValid = false
            formErrors[3] = "Password is required"
        }
        
        return isFormValid
        
    }
    
    func addUser() async{
        
        if(formValidation()){
            
            isPageLoading.toggle()
            
            try? await userModel.addUser(fullName: fullName, emailAddress: userName, mobileNumber: mobileNumber, address: address, state: state, country: country, lattitude: lattitude, longitude: longitude, password: passWord)
            
            if(userModel.responseStatus == 404){
                
                isPageLoading.toggle()
                
                toastMessage = userModel.responseMessage
                isToastPresented.toggle()
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                    withAnimation{
                        isToastPresented.toggle()
                    }
            }
            else{
                print(userModel.collectors,userModel.isLogged)
                if(userModel.isLogged){
                    UserDefaults.standard.set(true,forKey: "LoginState")
                    UserDefaults.standard.set(userModel.collectors.first!.id,forKey: "LoggedUserID")
                    UserDefaults.standard.set(userModel.collectors.first!.fullName,forKey: "LoggedUserName")
                    UserDefaults.standard.set(userModel.collectors.first!.lattitude,forKey: "LoggedUserLattitude")
                    UserDefaults.standard.set(userModel.collectors.first!.longitude,forKey: "LoggedUserLongitude")
                    UserDefaults.standard.set(userModel.collectors.first!.emailAddress,forKey: "LoggedUserEmail")
                    
                    try? await userModel.getUser(emailAddress: userModel.collectors.first!.emailAddress)
                    try? await pickupModel.getNearByPickups(lattitude: userModel.collectors.first!.lattitude, longitude: userModel.collectors.first!.longitude)
                    
                    pageState = "DashboardPage"
                    
                    isPageLoading.toggle()
                }
            }
        }
        
    }
    
    var body: some View {
        ZStack{
            if(isToastPresented){
                VStack{
                    Text("\(toastMessage)")
                        .font(.system(size: 14,weight: .regular))
                        .foregroundColor(.white)
                }
                .padding(.vertical,5)
                .padding(.horizontal,20)
                .background(Color.primaryGreen)
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color("PrimaryGreen"),lineWidth:4)
                )
                .padding(.horizontal,20)
                .zIndex(1)
                .offset(y:-360)
            }
            VStack{
                VStack{
                    Spacer()
                    Image(systemName: "arrow.3.trianglepath")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 60,weight: .black))
                        .foregroundColor(Color.primaryGreen)
                        .padding(.vertical,15)
                        .padding(.horizontal,20)
//                    Button(action:{}){
//                        HStack{
//                            Image(systemName: "apple.logo")
//                                .symbolRenderingMode(.hierarchical)
//                            Text("Sign in with Apple")
//                        }
//                        .padding()
//                        .font(.system(size: 17,weight: .bold))
//                        .frame(maxWidth: .infinity)
//                        .foregroundColor(.white)
//                        .background(.black)
//                        .cornerRadius(10)
//                    }
//                    .padding(.horizontal,20)
//                    HStack{
//                        VStack{
//                            Divider()
//                        }
//                        Text("or")
//                            .font(.system(size: 14))
//                            .padding(.horizontal,10)
//                        VStack{
//                            Divider()
//                        }
//                    }
//                    .padding(.vertical,20)
                    ScrollView{
                        VStack(spacing:20){
                            VStack(alignment:.leading){
                                if(formErrors[0] != ""){
                                    Text("\(formErrors[0])")
                                        .font(.system(size: 13,weight: .medium))
                                        .foregroundColor(.red)
                                }
                                VStack{
                                    TextField("Enter your name",text: $fullName)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                                        .onChange(of: fullName){
                                            formErrors[0] = ""
                                        }
                                }
                                .padding()
                                .background(Color.primaryBackground)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal,20)
                            VStack(alignment:.leading){
                                if(formErrors[1] != ""){
                                    Text("\(formErrors[1])")
                                        .font(.system(size: 13,weight: .medium))
                                        .foregroundColor(.red)
                                }
                                VStack{
                                    TextField("Enter your email",text: $userName)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                                        .onChange(of: userName){
                                            formErrors[1] = ""
                                        }
                                }
                                .padding()
                                .background(Color.primaryBackground)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal,20)
                            VStack(alignment:.leading){
                                if(formErrors[2] != ""){
                                    Text("\(formErrors[2])")
                                        .font(.system(size: 13,weight: .medium))
                                        .foregroundColor(.red)
                                }
                                VStack{
                                    TextField("Enter your mobile no.",text: $mobileNumber)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                                        .onChange(of: mobileNumber){
                                            formErrors[2] = ""
                                        }
                                }
                                .padding()
                                .background(Color.primaryBackground)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal,20)
                            VStack(spacing:20){
                                TextField("address", text: $address)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled(true)
                                    .padding()
                                    .foregroundColor(.black)
                                    .background(Color.primaryBackground)
                                    .cornerRadius(10)
                                    .disabled(true)
                                TextField("State", text: $state)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled(true)
                                    .padding()
                                    .foregroundColor(.black)
                                    .background(Color.primaryBackground)
                                    .cornerRadius(10)
                                    .disabled(true)
                                TextField("Country", text: $country)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled(true)
                                    .padding()
                                    .foregroundColor(.black)
                                    .background(Color.primaryBackground)
                                    .cornerRadius(10)
                                    .disabled(true)
                            }
                            .padding(.horizontal, 20)
                            VStack(alignment:.leading){
                                if(formErrors[3] != ""){
                                    Text("\(formErrors[3])")
                                        .font(.system(size: 13,weight: .medium))
                                        .foregroundColor(.red)
                                }
                                HStack{
                                    if(isPasswordVissible){
                                        TextField("Enter your password",text: $passWord)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled(true)
                                            .onChange(of: passWord){
                                                formErrors[3] = ""
                                            }
                                        Button(action:{
                                            withAnimation{
                                                isPasswordVissible.toggle()
                                            }
                                        }){
                                            Image(systemName: "eye")
                                                .symbolRenderingMode(.hierarchical)
                                        }
                                    }
                                    else{
                                        SecureField("Enter your password",text: $passWord)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled(true)
                                            .onChange(of: passWord){
                                                formErrors[3] = ""
                                            }
                                        Button(action:{
                                            withAnimation{
                                                isPasswordVissible.toggle()
                                            }
                                        }){
                                            Image(systemName: "eye.slash")
                                                .symbolRenderingMode(.hierarchical)
                                        }
                                    }
                                }
                                .padding()
                                .foregroundColor(.black)
                                .background(Color.primaryBackground)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal,20)
                            if(isPageLoading){
                                Button(action:{}){
                                    Text("Loading...")
                                        .padding()
                                        .font(.system(size: 17,weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.primaryGreen.opacity(0.5))
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal,20)
                                .disabled(true)
                            }
                            else{
                                Button(action:{
                                    Task{
                                        do{
                                            try? await addUser()
                                        }
                                        catch{
                                            print("Cathc Error: ")
                                            print(error)
                                        }
                                    }
                                }){
                                    Text("Sign up")
                                        .padding()
                                        .font(.system(size: 17,weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.primaryGreen)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal,20)
                            }
                        }
                    }
                }
                Spacer()
                VStack{
                    HStack(spacing:5){
                        Text("Already have an account?")
                        Button(action:{
                            withAnimation{
                                pageState = "SigninPage"
                            }
                        }){
                            Text("Signin")
                                .font(.system(size: 17,weight: .bold))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                .overlay(
                    Rectangle()
                        .frame(height: 1, alignment: .bottom)
                        .foregroundColor(.black.opacity(0.25)),
                    alignment: .top
                )
            }
        }
        .task {
            useMyLocation()
        }
        .animation(.easeInOut(duration: 0.7))
    }
}

struct SignupPreview: View {
    
    @State var pageState: String = "loginPage"
    @StateObject private var userModel = usersModel()
    @StateObject private var pickupModel = pickupsModel()
    
    var body: some View {
        SignupPage(userModel: userModel, pickupModel: pickupModel,pageState: $pageState, previousPageState: $pageState)
    }
}

#Preview {
    SignupPreview()
}
