require_relative '../../../config/environment'
require_relative 'main_menu_methods'
require_relative '../menus/reminder_menu'

def reminder_methods
  case reminder_menu
  when "1"
    puts "\nPlease enter your reminder:\n\n"
    note = gets.strip
    # # VICKY: remember to add menu/control options later!!!
    # if note == 'Q' || note =='q'
    #   options_methods
    # else
    @patient.add_reminder(note)
    puts "\nThank you for adding a reminder!\n\n"
    # end
    sleep(1)
    reminder_methods
  when "2"
    @patient.reminders.reload
    puts "These are your current reminders:"
    @patient.reminders.uniq.each_with_index{|reminder, index| puts "\n#{index+1}. #{reminder.note}\n";
    sleep(1)}

    reminder_methods
  when "3"
    main_menu_methods
  else
    puts "\nSorry, that is an invalid response."
    puts "Please enter a number from 1-3\n"
    sleep(1)
    reminder_methods
  end
end
