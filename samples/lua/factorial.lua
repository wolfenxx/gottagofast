local function calculateFactorial(n)
	if n == 0 or n == 1 then
		return 1
	end

	local result = 1
	for i = 2, n do
		result = result * i
	end
	return result
end

-- Format number with thousand separators
local function formatNumber(num)
	local formatted = tostring(num)
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then
			break
		end
	end
	return formatted
end

-- Trim whitespace from string
local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Check if string is a valid integer
local function isValidInteger(str)
	-- Check if string contains only digits (and optional minus sign)
	return str:match("^%-?%d+$") ~= nil
end

-- Get and validate user input
-- Returns number or nil if user wants to quit
local function getValidInput()
	local validInput = false
	local result = nil

	while not validInput do
		io.write("Enter a number between 1 and 20 to calculate its factorial (or 'q' to quit): ")
		io.flush()
		local input = io.read()

		-- Handle EOF (Ctrl+D on Unix, Ctrl+Z on Windows)
		if input == nil then
			return nil
		end

		local trimmedInput = trim(input)

		-- Check for empty input
		if trimmedInput == "" then
			print("Error: Input cannot be empty. Please try again.")
			-- Allow user to quit
		elseif trimmedInput:lower() == "q" then
			return nil
			-- Check if input is a valid integer
		elseif not isValidInteger(trimmedInput) then
			print("Error: Invalid input. Please enter a valid integer.")
		else
			-- Convert to number
			local number = tonumber(trimmedInput)

			-- Additional check (tonumber can return nil for invalid inputs)
			if number == nil then
				print("Error: Invalid input. Please enter a valid integer.")
				-- Check if it's an integer (not a float)
			elseif number ~= math.floor(number) then
				print("Error: Please enter a whole number.")
				-- Check range
			elseif number < 1 then
				print("Error: Number must be at least 1. Please try again.")
			elseif number > 20 then
				print("Error: Number must be 20 or less. Please try again.")
			else
				-- Valid input!
				result = number
				validInput = true
			end
		end
	end

	return result
end

-- Main function
local function main()
	print(string.rep("=", 50))
	print("Welcome to the Factorial Calculator!")
	print(string.rep("=", 50))

	while true do
		local number = getValidInput()

		-- Exit if user chose to quit
		if number == nil then
			print("\nThank you for using the Factorial Calculator. Goodbye!")
			break
		end

		-- Calculate and display result
		local factorial = calculateFactorial(number)
		print(string.format("\nThe factorial of %d is: %s", number, formatNumber(factorial)))
		print(string.rep("-", 50))
	end
end

-- Run the application
main()
