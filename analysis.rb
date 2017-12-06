require 'json'
require 'csv'
require 'pry-byebug'

def strFormat(n)
  n.gsub(/[.,]/, '.' => "", "," => ".")
end

def change(b,l)
  total = (l - b)/b * 100
end

total_employees = 0

orgs = %w(aglo agu ana anac anatel ancine aneel anp antaq anvisa bc capes cbtu cefetmg cefetrj ceitec cgu cnen cnpq codevasf conab cp2 cprm cvm dnit dnocs dnpm dpu eb ebc ebserh embrapa embratur enap epe fab fiocruz fnde fosorio funag funai funarte funasa fundacentro fundaj furg hcpa ibama ibc ibge ibram ifac ifal ifam ifap ifb ifba ifbaiano ifc ifce ifes iff iffarroupilha ifg ifgo ifma ifmg ifms ifmt ifnmg ifpa ifpb ifpe ifpi ifpr ifrj ifrn ifro ifrr ifrs ifsc ifse ifsertao ifsp ifsudestemg ifsul ifsuldeminas iftm ifto inep ines inmetro inpi inss ipea iphan mapa mb mcid mctic mdic mds me mec mf mi minc mj mma mme mp mpdft mpf mpt mre ms mt mte mtur nuclep pf pr previc prf serpro sudam sudeco sudene suframa susep tst ufabc ufac ufal ufam ufba ufc ufcg ufcspa ufersa ufes uff uffs ufg ufgd ufjf ufla ufma ufmg ufms ufmt ufob ufop ufopa ufpa ufpb ufpe ufpel ufpi ufpr ufra ufrb ufrgs ufrj ufrj2 ufrn ufrpe ufrr ufrrj ufs ufsb ufsc ufscar ufsj ufsm uft uftm ufu ufv ufvjm unb unifal unifap unifei unifesp unila unilab unipampa unir univasf utfpr valec)


high_wages = []

orgs.each do |org|
  filepath = "data/servidores_#{org}.json"

  serialized_employees = File.read(filepath)

  employees = JSON.parse(serialized_employees, symbolize_names: true)

  total_employees += employees.size
  sum_b = 0
  sum_l = 0
  employee_count = 0
  porcentage_positive = []
  high_wages = []

  employees.each do |employee|

    salary_b = strFormat(employee[:salary_b]).to_f
    salary_l = strFormat(employee[:salary_l]).to_f

    porcentage = change(salary_b,salary_l).round(1)

    # puts "#{porcentage}% - #{employee['name']} - #{employee['job']} - #{salary_b} - #{salary_l}"
    if salary_l > 0
      sum_l += salary_l
    end

    if salary_b > 0
      sum_b += salary_b
      employee_count += 1
    # else
    #   open("data-doc/#{org}.doc", "a") { |f| f << "#{employee[:name]}, " }
    end

    # if porcentage > 70 && porcentage < 100000
    #   porcentage_positive << { name: employee[:name], porcentage: porcentage, link: employee[:link] }
    # end

    if salary_b > 33700
      high_wages << employee
    end

  end

  # SERVIDORES SEM SALÁRIO

  filepath = "data/servidores_sem_salario_#{org}.json"

  serialized_employees = File.read(filepath)

  no_wage_employees = JSON.parse(serialized_employees, symbolize_names: true)

  no_wage_employees_count = no_wage_employees.count + (employees.count - employee_count)
  total_count = employee_count + no_wage_employees_count

  csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }

  CSV.open("salario.csv", "w") do |csv|
    csv << [org, employee_count, no_wage_employees_count,total_count]
  end


  puts "========================================================="
  puts "#{org.upcase}"
  puts

  # puts "#{org},#{employee_count},#{no_wage_employees_count},#{total_count}\n"

  # open("data-doc/#{org}.doc", "a") { |f| f << "#{org.upcase}\n\n" }

  # no_wage_employees.each do |employee|
  #   open("data-doc/#{org}.doc", "a") { |f| f << "#{employee[:name]}, " }
  #   print "#{employee[:name]}, "
  # end

  # puts "========================================================="
  # puts "Empregados sem salário - #{no_wage_employees.count}"
  # puts

  # SERVIDORES COM SALÁRIO

  # puts "========================================================="
  # puts "Médias - #{org.upcase}"
  # puts
  # puts "Salário bruto - R$ #{(sum_b/employee_count).round(2)}"
  # puts "Salário líquido - R$ #{(sum_l/employee_count).round(2)}"

  # puts "Com salário - #{employee_count}"
  # puts "Sem salário - #{no_wage_employees_count}"
  # puts "Total - #{total_count)}"
  # puts

  # puts "Total - #{employees.count}"

  # puts "---------------------------------------------------------"
  # puts "Variação acima de 70% no #{org.upcase}"
  # puts

  # porcentage_positive.each do |employee|
  #   puts "#{employee[:name]} - #{employee[:porcentage]}% - #{employee[:link]}"
  # end

  # puts "---------------------------------------------------------"
  # puts "Maiores salários no #{org.upcase}"
  # puts

  high_wages.each do |employee|
    puts "#{employee[:name]} - #{employee[:job]} - #{employee[:salary_b]} - #{employee[:salary_l]} - #{employee[:link]}"
  end
  puts "========================================================="
  # puts

end

  # puts high_wages.size
  # puts
# puts "Total de servidores: #{total_employees}"
