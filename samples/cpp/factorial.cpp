#include <iostream>
#include <string>

using namespace std;

long long calculateFactorial(int n) {
  if (n == 0 || n == 1) {
    return 1;
  }

  long long result = 1;
  for (int i = 2; i <= n; i++) {
    result *= i;
  }
  return result;
}

int getValidInput() {
  string input;

  while (true) {
    cout << "Enter a number between 1 and 20 to calculate its factorial (or "
            "'q' to quit): ";
    getline(cin, input);

    // Check for empty input
    if (input.empty()) {
      cout << "Error: Input cannot be empty. Please try again." << endl;
      continue;
    }

    // Allow user to quit
    if (input == "q" || input == "Q") {
      return -1;
    }

    // Try to convert to integer
    try {
      size_t pos;
      int number = stoi(input, &pos);

      // Check if entire string was converted (no trailing characters)
      if (pos != input.length()) {
        cout << "Error: Invalid input. Please enter a valid integer." << endl;
        continue;
      }

      // Check range
      if (number < 1) {
        cout << "Error: Number must be at least 1. Please try again." << endl;
        continue;
      }

      if (number > 20) {
        cout << "Error: Number must be 20 or less. Please try again." << endl;
        continue;
      }

      return number;

    } catch (const invalid_argument &) {
      cout << "Error: Invalid input. Please enter a valid integer." << endl;
    } catch (const out_of_range &) {
      cout << "Error: Number is too large. Please enter a number between 1 and "
              "20."
           << endl;
    }
  }
}

int main() {
  cout << string(50, '=') << endl;
  cout << "Welcome to the Factorial Calculator!" << endl;
  cout << string(50, '=') << endl;

  while (true) {
    int number = getValidInput();

    // Exit if user chose to quit
    if (number == -1) {
      cout << "\nThank you for using the Factorial Calculator. Goodbye!"
           << endl;
      break;
    }

    // Calculate and display result
    long long factorial = calculateFactorial(number);
    cout << "\nThe factorial of " << number << " is: " << factorial << endl;
    cout << string(50, '-') << endl;
  }

  return 0;
}
