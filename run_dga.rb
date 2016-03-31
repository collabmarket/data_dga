# Run all the scripts

def yesno(prompt = 'Continue?', default = 'y')
    alt = 'n' if default == 'y'
    alt = 'y' if default == 'n'
    q = "#{prompt}  [#{default}]/#{alt}: "
    input = [(print q), gets.rstrip.downcase][1]
    input = default if input.empty?
    return input == 'y'
end

run_test = yesno("Run Tests?", 'y')
run_data = yesno("Get all data?", 'n')

yesno("Inicio...")
load './test_dga.rb' if run_test
load './get_data.rb' if run_data
yesno("Finalizado")
