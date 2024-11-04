import fs from "node:fs";


function printAlien({ id, x, y }: { id: number; x: number; y: number }) {
  return `at(0,${id},${x},${y}).`;
}

function main() {
  const args = Bun.argv.slice(2)

  if (args.length < 3) {
    console.log('not enough arguments passed, 3 are necessary')
    process.exit(1)
  }

  const x = args[0];
  const y = args[1];
  const numberOfAliens = args[2];
  let output = `#const mx=${x}.
#const my=${y}.
#const a=${numberOfAliens}.

`;

  for (let i = 1; i <= numberOfAliens; i++) {
    const xPos = Math.round(Math.random() * x);
    // const xPos = x - i
    // const yPos = Math.round((Math.random() * (y - 1)) + 1);
    const yPos = y - i;

    output += printAlien({ id: i, x: xPos, y: yPos }) + "\n";
  }

  // fs.writeFileSync("latest_generated.lp", output);

  console.log(output);
}

main()
