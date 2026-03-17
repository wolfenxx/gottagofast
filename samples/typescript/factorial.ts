import * as readline from "readline";

function calculateFactorial(n: number): number {
  if (n === 0 || n === 1) {
    return 1;
  }

  let result = 1;
  for (let i = 2; i <= n; i++) {
    result *= i;
  }
  return result;
}

function getValidInput(rl: readline.Interface): Promise<number | null> {
  return new Promise((resolve) => {
    const promptUser = (): void => {
      rl.question(
        "Enter a number between 1 and 20 to calculate its factorial (or 'q' to quit): ",
        (input: string) => {
          const trimmedInput = input.trim();

          // Check for empty input
          if (trimmedInput === "") {
            console.log("Error: Input cannot be empty. Please try again.");
            promptUser();
            return;
          }

          // Allow user to quit
          if (trimmedInput.toLowerCase() === "q") {
            resolve(null);
            return;
          }

          // Try to parse as number
          const number = parseInt(trimmedInput, 10);

          // Check if it's a valid number
          if (isNaN(number)) {
            console.log("Error: Invalid input. Please enter a valid integer.");
            promptUser();
            return;
          }

          // Check if there are any non-numeric characters (except leading/trailing spaces)
          if (trimmedInput !== number.toString()) {
            console.log("Error: Invalid input. Please enter a valid integer.");
            promptUser();
            return;
          }

          // Check range
          if (number < 1) {
            console.log("Error: Number must be at least 1. Please try again.");
            promptUser();
            return;
          }

          if (number > 20) {
            console.log("Error: Number must be 20 or less. Please try again.");
            promptUser();
            return;
          }

          resolve(number);
        },
      );
    };

    promptUser();
  });
}

async function main(): Promise<void> {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  console.log("=".repeat(50));
  console.log("Welcome to the Factorial Calculator!");
  console.log("=".repeat(50));

  let running = true;

  while (running) {
    const number = await getValidInput(rl);

    // Exit if user chose to quit
    if (number === null) {
      console.log("\nThank you for using the Factorial Calculator. Goodbye!");
      running = false;
      break;
    }

    // Calculate and display result
    const factorial = calculateFactorial(number);
    console.log(
      `\nThe factorial of ${number} is: ${factorial.toLocaleString()}`,
    );
    console.log("-".repeat(50));
  }

  rl.close();
}

main().catch((error: Error) => {
  console.error("An error occurred:", error.message);
  process.exit(1);
});
