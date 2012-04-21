class String
	def random_string
		(0...8).map{65.+(rand(25)).chr}.join
	end
end