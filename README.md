# AssignmentProject

This repository contains a sample application which will fetch details using REST API and display on the screen.

<img src="https://github.com/nkwadgire/AssignmentProject/blob/develop/Screenshots/animatedGif.gif" height=500>

**The app has following folder structure:**

1. **Model**: It holds the API response data.
2. **service**: It performs the REST service API call.
3. **view**: It contains custom tableview cell.
3. **ViewModel**: It fetches the details using API service call and displays on the screen.

**Features:**
1. Application is designed using MVVM and decorator design patterns
2. Network connectivity check is performed using SystemConfiguration
3. Tableview and its tableView cells are implemented programatically
4. Constraints are set programatically using layout anchor
5. Application supports both iPhone and iPad starting from iOS 12.0 and above for both portrait and landscape orientations.
6. Refresh function is provided by both Pull to refresh or refresh button
7. Loading indicator is displayed during service call
8. SwiftLint is integrated to enforce swift style and conventions
9. Constant are defined in separate file
