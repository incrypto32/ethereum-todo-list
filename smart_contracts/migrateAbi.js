const fs = require("fs");
const path = require("path");
const { exit } = require("process");
const args = process.argv.slice(2);
const source = args[0];
const dest = args[1];
const sourcePath = path.join(__dirname, source);
const destPath = path.join(__dirname, dest);

if (!fs.existsSync(dest)) {
  console.log(`The directory ${dest} doesnt exist`);
  exit();
}

function processFile(file) {
  if (file.endsWith(".json")) {
    if (file != "Migrations.json") {
      let jsonData = JSON.parse(
        fs.readFileSync(path.join(sourcePath, file), "utf-8")
      );
      if (jsonData.abi) {
        const fileName = file.replace(".json", ".abi.json");
        writeToFile(jsonData.abi, fileName);
      } else {
        return console.error(
          "abi field dont exist for ",
          path.join(sourcePath, file)
        );
      }
    }else{
        console.log("ommited non json file ", path.join(sourcePath, file));
    }
  } else {
    console.log("ommited non json file ", path.join(sourcePath, file));
  }
}

function writeToFile(abi, fileName) {
  const jsonString = JSON.stringify(abi);

  fs.writeFile(path.join(dest, fileName), jsonString, (err) => {
    if (err) {
      console.log("Error writing file", err);
    } else {
      console.log("Successfully wrote file", fileName);
    }
  });
}

function migrateAbi(filename) {
  fs.readdir(sourcePath, function (err, files) {
    //handling error
    if (err) {
      return console.error("Unable to scan directory: " + err);
    }
    //listing all files using forEach
    files.forEach(processFile);
  });
}

migrateAbi("");
