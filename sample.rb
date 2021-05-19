class Person
  def initialize(name, age)
    @name = name
    @age = age
  

  def about_me 
    puts "I'm #{@name} and I'm #{@age} years old!"
   end

  

  def bank_account_number

    @account_number = 12_345
    puts "My bank account number is #{@account_number}."
  end
end

eric = Person.new('Eric', 26)
eric.about_me
eric.bank_account_number
