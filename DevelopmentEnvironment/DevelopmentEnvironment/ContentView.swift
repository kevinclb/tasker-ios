import SwiftUI
import Firebase

struct ContentView: View {
    @State var username = ""
    @State var usernames: [String] = []
    
    var body: some View {
        VStack{
            HStack{
                TextField("Enter your Name", text: $username)
                Button(action: {upload() }) {
                    Text("Upload")
                }
            }.onAppear(perform: {
                retrieve()
            })
            List(0..<usernames.count, id: \.self) {i in
                Text(usernames[i])
            }
        }
    }
    
    func upload(){
        let ref = Firestore.firestore()
        ref.collection("Users").document().setData(["username":username])
    }
    func retrieve(){
        let ref = Firestore.firestore()
        ref.collection("Users").addSnapshotListener {(snap, err) in
            if err != nil{
                print("There is an Error")
                return
            }
            for i in snap!.documentChanges{
                let documentId = i.document.documentID
                let username = i.document.get("username")
                DispatchQueue.main.async {
                    usernames.append("\(username!)")
                }
            }
        }
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
