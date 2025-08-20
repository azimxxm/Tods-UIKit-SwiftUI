## Todos app about

This app is built using both UIKit and SwiftUI, and it implements a caching system.
The project makes use of jsonplaceholder as a mock API. For caching, FileManager is used to store JSON files.
The API layer is implemented with URLSession, using Codable models and a fully programmatic UI approach.


# Personal opinion
I enjoy working with SwiftUI because it feels more modern, efficient, and expressive.
While UIKit is still powerful, it often requires a lot of boilerplate code.
Personally, I prefer writing clean and modern code with the latest tools and features.


## This is Task about

### TASK:

Fetch Todos from Mock API and display them in table view.You should implement pagination locally, because Mock API doesn't support it.You get 200 todos, but you should do pagination with 20.

Each table view cell should display todo's title and user's name.When cell is selected, Details page should be opened and you should show todo's and user's information.

Show searchbar in controller where you show the list of todos.Todos can be filtered by title or user's name.

Implement caching.When the app is opened without internet connection, you should show the cached todos.When the app is opened with internet connection, fetch from Mock API and renew cache.

Use UIKit with programmatic UI.

#### Mock API: URL (https://jsonplaceholder.typicode.com/)

#### get todos: URL (https://jsonplaceholder.typicode.com/todos) 
#### get users: URL (https://jsonplaceholder.typicode.com/users)

## Submission: Github link
