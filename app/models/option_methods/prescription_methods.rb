require_relative '../../../config/environment'
require_relative 'main_menu_methods'
require_relative '../menus/prescription_menu'

def prescription_methods
  case prescription_menu
  when "1"
    full_drug_name = ""

    puts "\nPlease enter the generic drug name (e.g., ibuprofen): \n\n"
    drug_name = gets.strip.downcase
    full_drug_name += drug_name

    puts "\nPlease enter the drug dosage (e.g., 10 mg): \n\n"
    drug_dosage = gets.strip.downcase
    full_drug_name += " #{drug_dosage}"

    puts "\nPlease enter the drug formulation (e.g., oral tablet)\n\n"
    drug_form = gets.strip.downcase
    full_drug_name += " #{drug_form}"

    puts "\nPlease enter the doctor's name:\n\n"
    doctor_name = gets.strip

    @patient.add_drug(full_drug_name, doctor_name)
    sleep(0.5)
    prescription_methods
  when "2"
    puts "\nHere are all your prescriptions. Please type the number you would like to remove\n"
    prescriptions = @patient.prescriptions.reload.uniq

    prescriptions.each_with_index{|pres, index| puts "\n#{index+1}. #{pres.name}\n"}
    drug_index = gets.strip.to_i - 1

    if check_string_empty(drug_index) && check_string_integer(drug_index) && prescriptions[drug_index]
      @patient.remove_drug(drug_index)
      prescriptions = @patient.prescriptions.reload.uniq
      puts "\nPrescription removed!\n"
      sleep(1)

      if prescriptions.length > 0
        puts "\nHere are your remaining prescriptions\n"
        sleep(1)
        prescriptions.each_with_index{|pres, index| puts "\n#{index+1}. #{pres.name}\n";
        sleep(0.5) }
      else
        puts "You have no remaining prescriptions in our records\n"
      end
    else
      puts "\nThat prescription does not exist in your records\n\n"
    end
    continue?
    prescription_methods
  when "3"
    puts "\nHere all your prescription. Please type the number you would like to edit\n"
    prescriptions = @patient.prescriptions.reload.uniq

    prescriptions.each_with_index{|pres, index| puts "\n#{index+1}. #{pres.name}\n"}
    drug_index = gets.strip.to_i - 1

    if prescriptions[drug_index]
      edit_prescription(prescriptions[drug_index])
    else
      puts "\nThat prescription does not exist in your records\n\n"
      sleep(1)
      prescription_methods
    end
  when "4"
    @patient.prescriptions.reload
    interactions_array = @patient.interactions
    #iterate through the interactions
    if interactions_array.length > 0
      interactions_array.each {|hash| binding.pry
        if @patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_1_name]}%")[0]
          if hash[:severity] != "N/A"
            puts "\nWe found this interaction:"
            sleep(1)
            puts "#{hash[:description]}"
            puts "The severity of this interaction is #{hash[:severity]}."
            if @patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_1_name]}%")[0].doctor != @patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_2_name]}%")[0].doctor
              puts "Please consider notifying #{@patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_1_name]}%")[0].doctor.name} and #{@patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_2_name]}%")[0].doctor.name}\n\n"
            else
              puts "Please consider notifying doctor(s) #{@patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_1_name]}%")[0].doctor.name}"
            end
            # @patient.prescriptions.find_by(rxcui: hash[:drug_1_rxcui]).doctor.name
          else
            puts "\nWe found this interaction: "
            sleep(1)
            puts "#{hash[:description]}"
            puts "The severity of this interaction is unknown by our database."
            #remember to store variables in yml
            if @patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_1_name]}%")[0].doctor != @patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_2_name]}%")[0].doctor
              puts "Please consider notifying doctors #{@patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_1_name]}%")[0].doctor.name} and #{@patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_2_name]}%")[0].doctor.name}\n\n"
            else
              puts "Please consider notifying doctors #{@patient.prescriptions.where('name LIKE ?', "%#{hash[:drug_1_name]}%")[0].doctor.name}"
            end
          end
        end
        continue?
        }
     else
       puts "\nWe found no interactions. Congrats!\n\n"
       continue?
     end

     prescription_methods
  when "5"
    @patient.prescriptions.reload
    puts "These are your current prescriptions:"
    sleep(1)
    @patient.prescriptions.uniq.each_with_index{|pres, index| puts "\n#{index+1}. #{pres.name}\n";
    sleep(0.5)}
    continue?
    prescription_methods
  when "6"
    main_menu_methods
  else
    puts "\nSorry, that is an invalid response."
    puts "Please enter a number from 1-6\n"
    sleep(1)
    prescription_methods
  end
end

def edit_prescription(prescription)
  puts "\nWhat would you like to edit?\n\n"
  puts "1. Drug dosage and formulation"
  puts "2. Doctor"

  response = gets.strip

  case response
  when "1"
    new_drug_name = prescription.name.split(" ")[0]

    puts "\nPlease enter new drug dosage:\n\n"
    dosage = gets.strip
    new_drug_name += " #{dosage}"

    puts "\nPlease enter new drug formulation:\n\n"
    formulation = gets.strip
    new_drug_name += " #{formulation}"

    prescription.name = new_drug_name
    prescription.save
    puts "Drug dosage and formulation updated!\n\n"
  when "2"
    puts "\nPlease enter new doctor name: \n\n"
    doctor_name = gets.strip
    new_doctor = Doctor.find_or_create_by(name: doctor_name)
    prescription.doctor = new_doctor
    prescription.save
    puts "Doctor name updated!\n\n"
  else
    puts "Sorry, that is an invalid response."
    puts "Please enter a number from 1-2.\n\n"
    sleep(1)
    edit_prescription(prescription)
  end

  sleep(1)
  prescription_methods
end
