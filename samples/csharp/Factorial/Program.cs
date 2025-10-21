using System;

namespace FactorialCalculator
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(new string('=', 50));
            Console.WriteLine("Welcome to the Factorial Calculator!");
            Console.WriteLine(new string('=', 50));

            while (true)
            {
                int? number = GetValidInput();

                // Exit if user chose to quit
                if (number == null)
                {
                    Console.WriteLine("\nThank you for using the Factorial Calculator. Goodbye!");
                    break;
                }

                // Calculate and display result
                long factorial = CalculateFactorial(number.Value);
                Console.WriteLine($"\nThe factorial of {number} is: {factorial:N0}");
                Console.WriteLine(new string('-', 50));
            }
        }

        static long CalculateFactorial(int n)
        {
            if (n == 0 || n == 1)
            {
                return 1;
            }

            long result = 1;
            for (int i = 2; i <= n; i++)
            {
                result *= i;
            }
            return result;
        }

        static int? GetValidInput()
        {
            while (true)
            {
                Console.Write("Enter a number between 1 and 20 to calculate its factorial (or 'q' to quit): ");
                string input = Console.ReadLine();

                // Allow user to quit
                if (string.IsNullOrWhiteSpace(input))
                {
                    Console.WriteLine("Error: Input cannot be empty. Please try again.");
                    continue;
                }

                if (input.Trim().ToLower() == "q")
                {
                    return null;
                }

                // Try to parse as integer
                if (!int.TryParse(input, out int number))
                {
                    Console.WriteLine("Error: Invalid input. Please enter a valid integer.");
                    continue;
                }

                // Check range
                if (number < 1)
                {
                    Console.WriteLine("Error: Number must be at least 1. Please try again.");
                    continue;
                }

                if (number > 20)
                {
                    Console.WriteLine("Error: Number must be 20 or less. Please try again.");
                    continue;
                }

                return number;
            }
        }
    }
}
