# grokci_main

A new Flutter project.

## TODO's : Existing issues with UI/Functionality to solve

### Creating widgets (instead of hardcode) for:
1. SearchBar.
2. Stepper.
3. Text Link button (account section).
4. Accordion for product details.


Open SearchEnabled screen (present in figma ui) as User clicks the search bar in ./lib/screens/search.dart


- Hardcoded ratings ?? (in product details) >>> should be variable
- Hardcoded images >>> why ?? >>> it should be provided by server !!
- Why there is hardcoded price description >>> it should be fetched from server >>> admin will provide these details
- product details seems dummy ?? >>> harcoded product details like (expiry details)
- Accordion in product details not working >>>
- Why address is harcoded in ./lib/screens/dashboard.dart at Ln. 110 >>> it should either show "Select address" or user's address
<!-- - have to revisit Category placement in ./lib/screens/dashboard.dart at Ln. : 149 -->
- details (category name and subtitle text) of Monthly Picks in Homepage should be provided by admin
- address.dart at Ln. 364 (GestureDetector): color of widget : unselected-{Pallet.tertiaryFill} selected-{Pallet.tonal}
- edit button in profile.dart should not edit username, it should open editprofile page(figma ui).
- There is a Search enabled screen in figma ui; As user clicks on Searchbar in ./lib/screens/search.dart, it should open search enabled screen. It is Search enabled page, where, a user can search any product, or type in the search bar.


### Redesigning Widgets:
1. Button.
2. TopAppBar.
3. NavigationBar.