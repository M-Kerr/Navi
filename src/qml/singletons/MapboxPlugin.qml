pragma Singleton

import QtQuick 2.0
import QtLocation 5.15

Plugin {
    name: "mapboxgl"

    // WARNING: Dev environment only, not meant for production
    property string token: "sk.eyJ1IjoibS1rZXJyIiwiYSI6ImNrbGgxanhxaDEzcWUybnFwMTBkcW8xMGkifQ.dw1csFMpo1bOvxNAvLxrmg"

    PluginParameter {
        name: "mapboxgl.access_token"
        value: token
    }

    PluginParameter {
        // Renders route lines underneath labels
        name: "mapboxgl.mapping.items.insert_before"
        value: "road-label-small"
    }

    PluginParameter {
        name: "mapboxgl.mapping.additional_style_urls"
        value: "mapbox://styles/m-kerr/cklo1x8c226o018mvgfvhxj6c/draft,mapbox://styles/m-kerr/cklqr3b7z6lq317og47js6g0j/draft,mapbox://styles/m-kerr/cklo1x8c226o018mvgfvhxj6c/draft,mapbox://styles/m-kerr/cklqr3b7z6lq317og47js6g0j/draft"
        //                value: "mapbox://styles/mapbox/navigation-guidance-day-v4,mapbox://styles/mapbox/navigation-guidance-night-v4,mapbox://styles/mapbox/navigation-preview-day-v4,mapbox://styles/mapbox/navigation-preview-night-v4"
    }
}
