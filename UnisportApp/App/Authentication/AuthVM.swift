//
//  AuthVM.swift
//  UnisportApp
//
//  Created by D K on 17.04.2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


struct User: Codable, Identifiable {
    let id: String
    let email: String
    let name: String
}

protocol AuthViewModelProtocol {
    var isValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentuser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signInAnonymously() async {
        do {
            let result = try await Auth.auth().signInAnonymously()
            self.userSession = result.user
            print("Signed in anonymously as user: \(String(describing: result.user.uid))")
        } catch {
            print("Error signing in anonymously: \(error.localizedDescription)")
        }
    }
    
    
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Error login: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, name: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(id: result.user.uid, email: email, name: name)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            print("User saved: \(user)")
            await fetchUser()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteUserAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "UserErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user is currently signed in."])))
            return
        }
        
        user.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentuser = nil
        } catch {
            print("Error signout: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentuser = try snapshot.data(as: User.self)
            print("Fetched User: \(String(describing: self.currentuser))")
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }
    
}
