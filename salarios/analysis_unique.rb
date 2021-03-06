require 'json'

filepath_all = 'data/total/servidores_total.json'
filepath_all_uniq = 'data/total/servidores_total_unicos.json'
filepath_all_no_wages = 'data/total/servidores_sem_salario_total.json'
filepath_all_no_wages_uniq = 'data/total/servidores_sem_salario_unicos.json'
e_group = []
e_group_uniq = []
e_group_no_wages = []
e_group_no_wages_uniq = []
total = 0
rate = 0

def strFormat(n)
  n.gsub(/[.,]/, '.' => "", "," => ".")
end

orgs = %w(aglo agu ana anac anatel ancine aneel anp antaq anvisa bc capes cbtu cefetmg cefetrj ceitec cgu cnen cnpq codevasf conab cp2 cprm cvm dnit dnocs dnpm dpu eb ebc ebserh embrapa embratur enap epe fab fiocruz fnde fosorio funag funai funarte funasa fundacentro fundaj furg hcpa ibama ibc ibge ibram ifac ifal ifam ifap ifb ifba ifbaiano ifc ifce ifes iff iffarroupilha ifg ifgo ifma ifmg ifms ifmt ifnmg ifpa ifpb ifpe ifpi ifpr ifrj ifrn ifro ifrr ifrs ifsc ifse ifsertao ifsp ifsudestemg ifsul ifsuldeminas iftm ifto inep ines inmetro inpi inss ipea iphan mapa mb mcid mctic mdic mds me mec mf mi minc mj mma mme mp mpdft mpf mpt mre ms mt mte mtur nuclep pf pr previc prf serpro sudam sudeco sudene suframa susep tst ufabc ufac ufal ufam ufba ufc ufcg ufcspa ufersa ufes uff uffs ufg ufgd ufjf ufla ufma ufmg ufms ufmt ufob ufop ufopa ufpa ufpb ufpe ufpel ufpi ufpr ufra ufrb ufrgs ufrj ufrj2 ufrn ufrpe ufrr ufrrj ufs ufsb ufsc ufscar ufsj ufsm uft uftm ufu ufv ufvjm unb unifal unifap unifei unifesp unila unilab unipampa unir univasf utfpr valec)

orgs.each do |org|

  filepath = "data/servidores_#{org}.json"
  filepath_no_wages = "data/servidores_sem_salario_#{org}.json"

  serialized_employees = File.read(filepath)

  employees = JSON.parse(serialized_employees, symbolize_names: true)

  employees.each do |e|

    salary_b = strFormat(e[:salary_b]).to_f

    salary_b > 0 ? e_group.push(e[:name]) : e_group_no_wages.push(e[:name])

  end

  serialized_employees = File.read(filepath_no_wages)

  employees = JSON.parse(serialized_employees, symbolize_names: true)

  employees.each { |e| e_group_no_wages.push(e[:name]) }

end

# File.open(filepath_all, 'wb') do |file|
#   file.write(JSON.generate(e_group))
# end

e_group_uniq = e_group.uniq { |e| e }

# File.open(filepath_all_uniq, 'wb') do |file|
#   file.write(JSON.generate(e_group_uniq))
# end

# File.open(filepath_all_no_wages, 'wb') do |file|
#   file.write(JSON.generate(e_group_no_wages))
# end

e_group_no_wages_uniq = e_group_no_wages.uniq { |e| e }

# File.open(filepath_all_no_wages_uniq, 'wb') do |file|
#   file.write(JSON.generate(e_group_no_wages_uniq))
# end

total = e_group_uniq.size + e_group_no_wages_uniq.size
rate = (e_group_no_wages_uniq.size * 100 / total).round(2)

puts "Com salário: #{e_group.size}"
puts "Com salário únicos: #{e_group_uniq.size}"
puts
puts "Sem salário: #{e_group_no_wages.size}"
puts "Sem salário únicos: #{e_group_no_wages_uniq.size}"
puts
puts "Total: #{total}"
puts "Proporção sem salário: #{rate}%"
