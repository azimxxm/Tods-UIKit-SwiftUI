//
//  TodosView.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

import SwiftUI

class TodosViewVC: UIViewController {
    
    private lazy var hostingController = UIHostingController(
        rootView: TodosView()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
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



struct TodosView: View {
    @StateObject private var viewModel = TodosVM()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.displayedTodos) { todo in
                            NavigationLink {
                                DetailPageView(todo: todo)
                            } label: {
                                cell(with: todo)
                            }

                        }
                    }
                    .padding()
                }
            }
            .searchable(text: $viewModel.searchText, prompt: Text("Search by title"))
            .task(priority: .background) {
                await viewModel.fetchTodos()
            }
        }
        .onChange(of: viewModel.searchText) { oldValue, newValue in
            viewModel.filter(by: newValue)
        }
        
    }
    
    @ViewBuilder
    private func cell(with todo: Todo)-> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(todo.completed ? Color.green.gradient : Color.orange.gradient)
                    .frame(width: 12, height: 12)
                
                Text(todo.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            
            Text(todo.completed ? "Completed" : "Incomplete")
                .foregroundColor(todo.completed ? .green : .red)
                .font(.caption)
                .padding(.top, 2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 2)
        )
    }
}

#Preview {
    Group {
        TodosView()
            .preferredColorScheme(.light)
        
        TodosView()
            .preferredColorScheme(.dark)
    }
}
