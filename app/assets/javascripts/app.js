
function recenterMap(latLng){
  marker.setLatLng(latLng);
  map.panTo(latLng);
};

var washingtonSquare = L.latLng(40.7308, -73.9975);
