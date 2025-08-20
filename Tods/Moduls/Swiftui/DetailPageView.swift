//
//  DetailPageView.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//


import SwiftUI

import SwiftUI

class DetailPageViewVC: UIViewController {
    var todo: Todo?
    private lazy var hostingController = UIHostingController(
        rootView: DetailPageView(todo: todo)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwiftUIView()
    }
    
    private func addSwiftUIView() {
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        hostingController.didMove(toParent: self)
    }
}


struct DetailPageView: View {
    let todo: Todo?
    
    var body: some View {
        ScrollView {
            if let todo = todo {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Todo Detail")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("ID:")
                            .fontWeight(.semibold)
                        Text("\(todo.id)")
                    }
                    
                    HStack {
                        Text("Title:")
                            .fontWeight(.semibold)
                        Text(todo.title)
                    }
                    
                    HStack {
                        Text("Completed:")
                            .fontWeight(.semibold)
                        Text(todo.completed ? "✅ Yes" : "❌ No")
                            .foregroundColor(todo.completed ? .green : .red)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .navigationTitle("Todo \(todo?.id.description ?? "no id")")
        .navigationBarTitleDisplayMode(.inline)
    }
}
