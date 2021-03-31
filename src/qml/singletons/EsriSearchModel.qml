pragma Singleton

import QtQuick 2.0
import QtLocation 5.15
import QtPositioning 5.15
import Logic 1.0

PlaceSearchModel {
    id: root

    plugin: EsriPlugin
    searchArea: _searchRegion

    property variant searchLocation: QtPositioning.coordinate(0, 0)
    property real searchRadius: 5000
    property variant _searchRegion: QtPositioning.circle(searchLocation,
                                                        searchRadius)

    onSearchTermChanged: {
        //TODO: add logic to force update() the model if search input has
        // stopped. I think the update() function is on a timer and may not
        // search the final token
        if (searchTerm) {
            update()
        }
        else reset();
    }

    onStatusChanged: {
        switch (status) {
        case PlaceSearchModel.Null: break; //print("No query executed");
        case PlaceSearchModel.Ready: break; //print("Search results ready");
        case PlaceSearchModel.Loading: break; //print("Search loading");
        case PlaceSearchModel.Error: print("Error occurred during previous search query:",
                                           errorString()); break;
        }
    }
}

//    // TODO
//    PlaceSearchSuggestionModel{
//    }
