import fs from "node:fs";

function printAlien({ id, x, y }: { id: number; x: number; y: number }) {
  return `at(0,${id},${x},${y}).`;
}

function main() {
  const x = 20;
  const y = 50;
  const numberOfAliens = 20;
  let output = `#const mx=${x}.
#const my=${y}.
#const a=${numberOfAliens}.

`;

  for (let i = 1; i <= numberOfAliens; i++) {
    // const xPos = Math.round(Math.random() * x);
    const xPos = x - i
    // const yPos = Math.round((Math.random() * (y - 1)) + 1);
    const yPos = y - i;

    output += printAlien({ id: i, x: xPos, y: yPos }) + "\n";
  }

  fs.writeFileSync("latest_generated.lp", output);

  return output;
}

console.log(main());
