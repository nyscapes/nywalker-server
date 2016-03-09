
function recenterMap(latLng){
  marker.setLatLng(latLng).setOpacity(70);
  map.panTo(latLng);
};

var washingtonSquare = L.latLng(40.7308, -73.9975);
