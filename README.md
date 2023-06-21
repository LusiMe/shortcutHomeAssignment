#  Comic App
## Quick overview
The application allows browse through comics one by one, see description and explanation as modal windows, search for comic by number and by title.
In project was used MVC design pattern and Swift with Storyboard. For dependency management was used dependency injection. 
Project separated for 4 big blocks: Model, View, Controller and Services.
To write this project I used Xcode Version 14.0, Swift 5, tested on iPhone 14 Pro Max emulator

## Feature explanation
Drag to the left to browse through comics. At the bottom you can see two buttons which lead to explanation and description respectedly.  If you enter only numbers in search bar then it will search by ID. If it will be words it will search by title.

## Thought process
Including all the features that were proposed and even imagining more, this app is not supposed to grow into a big and complex system. Furthermore, the MVC pattern is supposed to satisfy all current and future requirements. Also, this app does not require frequent content updates, so the MVVM pattern was not necessary to implement.
Dependency injection was chosen because it simplifies extending apps functionality. It also helps with testing, as it helps with mocking behavior.

