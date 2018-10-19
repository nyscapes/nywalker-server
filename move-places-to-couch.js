const process = require("process");
const fs = require("fs");
const path = require("path");
const NodeCouchDb = require("node-couchdb");

const couch = new NodeCouchDb();
const dbName = "text-walker";

couch.dropDatabase(dbName).then(
  () => createDB(),
  err => {
    process.stdout.write(err + "\n");
    createDB();
  }
);

function createDB() {
  couch.createDatabase(dbName).then(
    () => {
      process.stdout.write(`db ${dbName} created\n`);
      readPlacesFile();
    },
    err => {
      process.stdout.write(err + "\n");
    }
  );
}

function readPlacesFile() {
  fs.readFile(path.join("data", "places.json"), (err, data) => {
    if (err) throw err;
    cleanAssociations(JSON.parse(data));
  });
}

// Place.nicknames is a doubly encoded JSON string, so it needs separate parsing.
// and then write the json file
function cleanAssociations(data) {
  const cleanData = data.map(place => {
    place.nicknames = JSON.parse(place.nicknames);
    return place;
  });
  fs.writeFile(
    path.join("data", "places-clean.json"),
    JSON.stringify(cleanData, null, 2),
    err => {
      if (err) throw err;
      process.stdout.write("places-clean.json written.\n");
    }
  );
}
