class AddDataToUdacity < ActiveRecord::Migration
  def change
  	url = 'https://www.udacity.com/public-api/v0/courses'
	uri = URI(url)
	response = Net::HTTP.get(uri)
	data = JSON.parse(response)
	titles = ["Developing Android Apps",
		"Deep Learning",
		"Android Development for Beginners",
		"Advanced Android App Development",
		"Material Design for Android Developers",
		"The MVC Pattern in Ruby",
		"Intro to HTML and CSS",
		"JavaScript Basics",
		"Programming Foundations with Python",
		"Intro to iOS App Development with Swift",
		"Intro to Java Programming",
		"Responsive Web Design Fundamentals",
		"Intro to Machine Learning",
		"Intro to Hadoop and MapReduce",
		"Intro to Data Science",
		"Web Development",
		"Intro to Artificial Intelligence",
		"Computability, Complexity & Algorithms",
		"Reinforcement Learning",
		"Applied Cryptography",
		"Machine Learning"]

	fields = ["title", "expected_learning", "summary", "level", "image", "homepage", "short_summary"]
	data["courses"].each do|d|
		if titles.include?(d["title"])
			ud = Udacity.new(d.select{|k,v| fields.include?(k.to_s) })
			ud.save!			
		end
	end
  end
end
