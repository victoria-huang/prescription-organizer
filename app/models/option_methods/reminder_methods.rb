require_relative '../../../config/environment'
require_relative 'main_menu_methods'
require_relative '../menus/reminder_menu'

def reminder_methods
  case reminder_menu
  when "1"
    puts "\nPlease enter your reminder:\n\n"
    note = gets.strip
    @patient.add_reminder(note)
    puts "\nThank you for adding a reminder!\n\n"
    sleep(1)
    reminder_methods
  when "2"
    list_reminders
    reminder_methods
  when "3"
    #add code here later
    reminder_methods
  when "4"
    list_reminders
    puts "\nPlease enter the number you would like to remove:\n"
    which_number_remove
  when "5"
    @patient.reminders.reload
    if @patient.reminders.count > 0
      puts "\nAre you sure you want to delete all you reminders? (y/n)"
      del_all_reminders_response
    else
      puts "\nYou currently have no reminders!\n\n"
      sleep(1)
      reminder_methods
    end
  when "6"
    main_menu_methods
  else
    puts "\nSorry, that is an invalid response."
    puts "Please enter a number from 1-6\n\n"
    sleep(1)
    reminder_methods
  end
end

def list_reminders
  @patient.reminders.reload

  if @patient.reminders.count > 0
    puts "\nThese are your current reminders:"
    @patient.reminders.uniq.each_with_index{|reminder, index| puts "\n#{index+1}. #{reminder.note}\n";
    sleep(1)}
  else
    puts "\nYou currently have no reminders!\n\n"
    sleep(1)
  end
end

def del_one_reminder_response(number)
  response = gets.strip
  case response
   when "yes", "y"
     Reminder.delete(Reminder.all[number.to_i - 1].id)
     sleep(0.5)
     puts "\nThank you, your reminder has been deleted.\n\n"
     sleep(0.5)
     reminder_methods
   when "no", "n"
     puts "\nOkay, returning to Reminders Menu.\n\n"
     sleep(1)
     reminder_methods
   else
     puts "\nInvalid response, please enter yes or no\n\n"
     del_one_reminder_response
   end
 end

def which_number_remove
  number = gets.strip
  if check_string(number) && @patient.reminders[number.to_i - 1]
    puts "\nAre you sure you want to delete this reminder? (y/n)"
    del_one_reminder_response(number)
  else
    puts "\nInvalid response, please enter a number from your list of reminders\n\n"
    which_number_remove
  end
end

def del_all_reminders_response
  response = gets.strip
  case response
  when "yes", "y"
    Reminder.delete_all
    sleep(1)
    puts "Thank you, your reminders have been deleted.\n\n"
    sleep(0.5)
    reminder_methods
  when "no", "n"
    puts "Okay, returning to Reminders Menu.\n\n"
    sleep(1)
    reminder_methods
  else
    puts "Invalid response, please enter yes or no\n\n"
    del_all_reminders_response
  end
 end
