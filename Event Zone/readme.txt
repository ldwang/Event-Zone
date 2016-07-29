"Event Zone" App

Description: This App is to help people with the need of checking events/meetings aross different timezones/regions with the local date and time information.

Actions and Steps:

"Event List":
-- The App shows a "Event List" TableView, with the event title, location1&2 addresses, local start date/time and timezone info. The inital list is empty.
-- Tap the up right "+" button to add the new event. It will show the "Event Detail" ViewController for adding new event.
-- If there is/are event(s) showed, tap the specific event and it will show the "Event Detail" ViewController with the detailed information.
-- Swipe the event towards left to delete it.

"Event Detail":
-- If it's new event, the up right button shows "Add" and disabled by default. The event title, location1, and location2 information need to be filled or selected, and then the "add" button will be enabled. After tapping the "add" button, the new event is saved in the CoreData store and the view returns to the "Event List" view.
-- Tap the "Location1" or "Location2" table cell will show the "Location Search" view.
-- Tap the Location1/Location2's '"Starts" or "Ends" cell will expand a datepicker to choose the event start or end date/time. Tap the cell again will folder the datepicker. When the starts/ends date/time is changed in one location, the other location's starts/ends date/time will be automatically changed as well to the local date/time.
-- The Time Zone Cell is not editable. It's from the location's time zone info by querying GoogleMap TimeZone API.
-- There is a map at the bottom to show these 2 locations on the map with a blue dashed line. If there is only one location selected, only one location will be showed on the map. By default, the map is empty without any location annotation.
-- If it's an existing event, the up right button shows "Edit" to allow editing. When "Edit" button is tapped, the up right button changes to "Done" and "the event tile, location1/location2, "Starts"/"Ends" cells can be changed/edited, otherwise it shows just the existing event information. Tap the "Done" button" after the editing to return to "Event List" View.
-- Tap the "Cancel" Button to discard the changes/new event and return to "Event List" View.

"Location Search":
-- After tapping the Location1 or Location2 cell in "Event Detail", a "Location Search" view is presented. with a searchbar.
-- type the address/location in the search bar, it will show a list of addresses. Tap one of the address from the list will return to the "Event Detail" View and the location info will be shown accordingly. The Time Zone info, Starts and Ends date/time will also be changed to the right local time zone of the location.
-- Tap the up left "<" button will discard the location search and return to the "Event Detail" View.
