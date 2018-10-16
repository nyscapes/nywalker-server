const NodeCouchDb = require("node-couchdb");
const process = require("process");
const fs = require("fs");
const path = require("path");

const couch = new NodeCouchDb();
const dbName = "text-walker";
couch.createDatabase(dbName).then(() => {
  readPlacesFile();
}, err => {
  process.stdout.write(err + "\n");
});

function readPlacesFile(){
  fs.readFile(path.join("data", "places.json"), (err, data) => {
    if (err) throw err;
    cleanAssociations(JSON.parse(data));
  });
}

// place.nicknames is a doubly encoded JSON string, so it needs separate parsing.
// and then write the json file
function cleanAssociations(data){
  fs.writeFile(path.join("data", "places-clean.json"),
    JSON.stringify(
      data.map(place => {
        place.nicknames = JSON.parse(place.nicknames);
        return place;
      }),
      null,
      2
    ),
    err => {
      if (err) throw err;
      process.stdout.write("places-clean.json written.\n");
    }
  );
}
