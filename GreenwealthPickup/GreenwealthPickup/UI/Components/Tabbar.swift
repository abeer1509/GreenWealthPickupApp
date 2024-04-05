import SwiftUI

struct Tabbar: View {
    
    @Binding var pageState: String
    @Binding var previousPageState: String
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    var body: some View {
        VStack{
            HStack(alignment:.center, spacing: 60){
                if(pageState == "PickupPage" || pageState == "DashboardPage" || pageState == "HistoryPage" || pageState == "CurrentPage" || pageState == "HelpPage"){
                    Button(action:{
                        withAnimation{
                            pageState = "DashboardPage"
                        }
                    }){
                        VStack(spacing:5){
                            Image(systemName: "arrow.3.trianglepath")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 18, weight: .heavy))
                            Text("Requests")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(Color.primaryGreen)
                    }
                }
                else{
                    Button(action:{
                        withAnimation{
                            pageState = "DashboardPage"
                        }
                    }){
                        VStack(spacing:5){
                            Image(systemName: "arrow.3.trianglepath")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 18, weight: .heavy))
                            Text("Requests")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(.black.opacity(0.5))
                    }
                }
                if(pageState == "QueuePage" || pageState == "ActionPage"){
                    Button(action:{
                        withAnimation{
                            if(isLogged){
                                pageState = "QueuePage"
                                previousPageState = "LeaderboardPage"
                            }
                            else{
                                pageState = "SigninPage"
                                previousPageState = "ProfilePage"
                            }
//                            pageState = "LeaderboardPage"
                        }
                    }){
                        VStack(spacing:5){
                            Image(systemName: "doc.plaintext")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 18, weight: .heavy))
                            Text("Orders")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(Color.primaryGreen)
                    }
                }
                else{
                    Button(action:{
                        withAnimation{
                            if(isLogged){
                                pageState = "QueuePage"
                                previousPageState = "LeaderboardPage"
                            }
                            else{
                                pageState = "SigninPage"
                                previousPageState = "ProfilePage"
                            }
//                            pageState = "LeaderboardPage"
                        }
                    }){
                        VStack(spacing:5){
                            Image(systemName: "doc.plaintext")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 18, weight: .heavy))
                            Text("Orders")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(.black.opacity(0.5))
                    }
                }
                if(pageState == "ProfilePage"){
                    Button(action:{
                        withAnimation{
                            if(isLogged){
                                pageState = "ProfilePage"
                                previousPageState = "ProfilePage"
                            }
                            else{
                                pageState = "SigninPage"
                                previousPageState = "ProfilePage"
                            }
//                            pageState = "ProfilePage"
                        }
                    }){
                        VStack(spacing:5){
                            Image(systemName: "person")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 18, weight: .heavy))
                            Text("Profile")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(Color.primaryGreen)
                    }
                }
                else{
                    Button(action:{
                        withAnimation{
                            if(isLogged){
                                pageState = "ProfilePage"
                                previousPageState = "ProfilePage"
                            }
                            else{
                                pageState = "SigninPage"
                                previousPageState = "ProfilePage"
                            }
//                            pageState = "ProfilePage"
                        }
                    }){
                        VStack(spacing:5){
                            Image(systemName: "person")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 18, weight: .heavy))
                            Text("Profile")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(.black.opacity(0.5))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(.white)
        .overlay(
            Rectangle()
                .frame(height: 1, alignment: .bottom)
                .foregroundColor(.black.opacity(0.25)),
            alignment: .top
        )
    }
}

struct TabbarPreview: View {
    
    @State var pageState = "DashboardPage"
    
    var body: some View {
        Tabbar(pageState: $pageState, previousPageState: $pageState)
    }
}

#Preview {
    TabbarPreview()
}
