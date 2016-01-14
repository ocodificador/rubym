require_relative 'rubym'

t = Mumps::Gtm.new
puts t.version
puts t.data("teste",'"Joao Batista Silva",1,2,3')
puts t.set("teste",'"JBS",1,2,3','teste de conteudo 1')
puts t.set("teste",'"JBS",1,2,3,4','teste de conteudo 2')
puts t.get("teste",'"Joao Batista Silva",1,2,3')
puts t.get("teste",'"Joao Batista Silva",1,2,5')
puts t.kill("teste","1,2,3")
