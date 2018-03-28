require_relative '../config/environment'

def prescription_menu
  puts "\nWhat would you like to do?\n\n"
  puts "Choices:"
  puts "1. Add a prescription"
  puts "2. Remove a prescription"
  puts "3. Check if existing prescriptions have any interactions"
  puts "4. Get a list of all your existing prescriptions"
  puts "5. Return to main menu"
  puts "6. Exit program\n\n"

  response = gets.strip
end
