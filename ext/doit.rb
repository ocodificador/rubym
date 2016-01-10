require_relative 'rubym'

t = Mumps::Gtm.new
puts t.version
puts t.data("teste",'"Joao Batista Silva",1,2,3')
puts t.get("teste",'"Joao Batista Silva",1,2,3')
puts t.kill("teste","1,2,3")
