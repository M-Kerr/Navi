import QtQuick 2.0
import QtLocation 5.15
import QtPositioning 5.15

PlaceSearchModel {
    id: searchModel

    property variant searchLocation: QtPositioning.coordinate(0, 0)
    property real searchRadius: 5000
    property variant _searchRegion: QtPositioning.circle(searchLocation,
                                                        searchRadius)

    searchArea: _searchRegion

    onSearchTermChanged: {
        //TODO: add logic to force update() the model if search input has
        // stopped. I think the update() function is on a timer and may not
        // search the final token
        if (searchTerm)
        {
            update()
        }
    }

    onStatusChanged: {
        switch (status) {
        case PlaceSearchModel.Null: print("No query executed"); break;
//        case PlaceSearchModel.Ready: print("Search results available"); break;
//        case PlaceSearchModel.Loading: print("Loading search query"); break;
        case PlaceSearchModel.Error: print("Error occurred during previous search query:",
                                           errorString());
            break;
        }
    }
}







//    // TODO
//    PlaceSearchSuggestionModel{
//    }
