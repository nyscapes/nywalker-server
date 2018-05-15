
function recenterMap(latLng){
  marker.setLatLng(latLng).setOpacity(70).update();
  map.panTo(latLng);
};

var washingtonSquare = L.latLng(40.7308, -73.9975);

$( document ).ready(function(){

  $("#autofillbutton").on("click", function(e) {
    e.preventDefault();
    $.post("/reload-autofill", { reload: true }, (d) => {
      nicknames = JSON.parse(d).nicknames;
      $( this ).html("Repopulated. Reload page.").removeClass("btn-warning").addClass("btn-success"); 
    });
  });

});
