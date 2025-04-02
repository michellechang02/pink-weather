Grading
Note: This rubric is still undergoing a few changes. It'll be finalized by the end of this week.

This assignment is worth 100 points, broken down as follows:

Home and Weather Views (25 points)
- 5 points: The list of favorited locations is displayed somewhere (on the home screen or elsewhere)
- 5 points: Navigation between screens is easy to use and works correctly
- 5 points: Home screen has a field or fields for user input, and a button to submit
- 5 points: Location detail screen shows the location name FROM THE GEOCODING API, not the user input, and at least the 3 required fields
- 5 points: Location detail screen has a button to favorite/unfavorite the current location

Networking & API Calls (25 points)
- 5 points: App correctly uses Geocoding API
- 5 points: App correctly decodes result of Geocoding API
- 5 points: App correctly uses Weather API
- 5 points: App correctly decodes result of Weather API
- 5 points: App calls these API functions at the appropriate locations

Persistent Data Storage (25 points)
- 5 points: Decided on appropriate type of persistent storage for data
- 20 points: Correct use of persistent storage (UserDefaults not allowed)
- 10 points: App correctly sets up whichever framework was chosen
- 10 points: App correctly uses whichever framework was chosen, and writes/reads data from it correctly

App Architecture (15 points)
- 5 points: App uses a model struct to represent the locations and weather data
- 5 points: App uses a view model to keep track of the data used throughout the app
- 5 points: App successfully uses @State and/or @Environment to share the view model between different screens

Code Quality (10 points)
10 points: Code is readable (i.e. indentation and naming of symbols is reasonable)

Deductions
-5 points: Xcode project contains a broken file reference preventing compilation
-20 points: App doesn't compile

General bugs (those not covered in the above deductions) will be subject to these deductions:
-2 points: Minor bug, e.g. a UI/UX issue that appears in limited circumstances and doesn't affect the core flow
-5 points: Major bug, e.g. a bug that prevents the core flow of the app but can be worked around in-app
-10 points: Fatal bug, e.g. a bug that requires code modification to continue testing the core flow

Crashes on launch, or during major parts of the app flow, will fall into this category
Bugs encountered when testing extra credits will be deducted from their respective extra credit points.

Extra Credits
Current location (+5) Add a way to autofill the user's current location into the input fields (see Lecture 7 for details on getting location!)
Map (+5): Show the given location in a map in the location detail view.
