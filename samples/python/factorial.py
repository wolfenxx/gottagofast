def calculate_factorial(n):
    if n == 0 or n == 1:
        return 1

    result = 1
    for i in range(2, n + 1):
        result *= i
    return result


def get_valid_input():
    while True:
        try:
            user_input = input(
                "Enter a number between 1 and 20 to calculate its factorial (or 'q' to quit): "
            )

            # Allow user to quit
            if user_input.lower() == "q":
                return None

            # Convert to integer
            number = int(user_input)

            # Check range
            if number < 1:
                print("Error: Number must be at least 1. Please try again.")
                continue
            elif number > 20:
                print("Error: Number must be 20 or less. Please try again.")
                continue

            return number

        except ValueError:
            print("Error: Invalid input. Please enter a valid integer.")


def main():
    print("=" * 50)
    print("Welcome to the Factorial Calculator!")
    print("=" * 50)

    while True:
        number = get_valid_input()

        # Exit if user chose to quit
        if number is None:
            print("\nThank you for using the Factorial Calculator. Goodbye!")
            break

        # Calculate and display result
        factorial = calculate_factorial(number)
        print(f"\nThe factorial of {number} is: {factorial:,}")
        print("-" * 50)


if __name__ == "__main__":
    main()
