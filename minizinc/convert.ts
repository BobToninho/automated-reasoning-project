const re = /at\(0,(\d+),(\d+),(\d+)/;

const alienXs = []
const alienYs = []

// Read lines from stdin
for await (const line of console) {
  if (line === "") {
    continue;
  }

  const found = line.match(re);
  const alienId = found[1];
  const alienX = found[2];
  const alienY = found[3];

  alienXs.push(alienX)
  alienYs.push(alienY)
}

/*
array[1..a] of 0..mx-1: aliens_x_initial = [7, 7, 9];
array[1..a] of 0..my-1: aliens_y_initial = [9, 9, 9];
*/
console.log(`array[1..a] of 0..mx-1: aliens_x_initial = [${alienXs.toString()}];`);
console.log(`array[1..a] of 0..my-1: aliens_y_initial = [${alienYs.toString()}];`);
