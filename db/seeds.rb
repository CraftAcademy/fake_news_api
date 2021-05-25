require 'uri'

titles = [
  'New Vaccine Conspiracy Theories Are Going Viral in Arabic',
  '‘It is a trap!’: Inside the QAnon attack that never happened',
  'New Year 2020: 10 Moments This Decade That Made Us Say, "Wait, What?"',
  "Amateur Rocket-Maker Finally Launches Himself Off Earth - Now To Prove It's Flat",
  'The Covid-19 Vaccine Will Contain A Microchip',
  'Canada SWAT team arrest pastor Artur Pawlowski, who’s been holding church services in defiance of the country’s strict COVID lockdown measures.',
  'Moderna Chief Medical Officer Confirms mRNA Injection For COVID-19 Can Change Your Genetic Code.'

]
teasers = [
  'Facebook has been criticized for failing to curb misinformation in English. But little attention has been paid to the scale of the problem in Arabic.',
  'Why fears of violence on March 4, the mythical day Trump was supposed to be inaugurated to a second term, proved unfounded.',
  'Happy New Year 2020: This list of ten moments includes not just personalities in India and across the world, but also certain events which have had a number of consequences for those involved.',
  'Mike Hughes, a California man who is most known for his belief that the Earth is shaped like a Frisbee, finally blasted off into the sky in a steam-powered rocket he had built himself.',
  'Despite the majority of us keeping our fingers crossed for a Covid-19 vaccine to be developed as soon as possible, others on the internet are sceptical about the benefits of a such a cure.',
  'Several police vehicles surrounded Pawlowski after he finished a service on Saturday, ordered him out of his car and made him kneel down on a busy highway to arrest him.',
  'From a TEDx Beacon Street talk occurred in 2017, Tal Zaks, chief medical officer of Moderna, Inc., one pharmaceutical company manufacturer of the experimental mRNA technology injection, confirms mRNA injection for COVID-19 can change your genetic code or DNA.'
]
body = [
  ['Science gets a lot of respect these days. Unfortunately, it’s also getting a lot of competition from misinformation. Seven in 10 Americans think the benefits from science outweigh the harms, and nine in 10 think science and technology will create more opportunities for future generations. Scientists have made dramatic progress in understanding the universe and the mechanisms of biology, and advances in computation benefit all fields of science.
   In my 30 years of studying and promoting scientific literacy, I’ve found that college educated adults have large holes in their basic science knowledge and they’re disconcertingly susceptible to superstition and beliefs that aren’t based on any evidence. One way to counter this is to make it easier for people to detect pseudoscience online. To this end, my lab at the University of Arizona has developed an artificial intelligence-based pseudoscience detector that we plan to freely release as a web browser extension and smart phone app.'],
  ['In a joint intelligence bulletin earlier this week, the FBI and Department of Homeland Security delivered a jarring warning to state and local law enforcement: violent domestic extremists motivated by the QAnon conspiracy theory might be mobilized to action because they believed Donald Trump would be inaugurated on March 4.'],
  ['New Delhi: As this decade comes to an end, there have been quite a few moments that people have hoped and prayed had never happened. While these \'foot-in-mouth\' moments have numbered in the hundreds and thousands in this decade itself, we\'ve rounded up ten of the choicest moments, some of them quite embarrassing for those concerned.'],
  ["The 61-year-old limo driver and daredevil-turned-rocket-maker soared about 1,875 feet above the Mojave Desert on Saturday afternoon, the Associated Press reported. Hughes\'s white-and-green rocket, bearing the words 'FLAT EARTH,' propelled vertically about 3 p.m. Pacific time and reached a speed of about 350 mph, Waldo Stakes, who has been helping Hughes, told the AP. Hughes deployed two parachutes while landing, the second one just moments before he plopped down not far from his launching point."],
  ["In fact, Youtuber David Icke claimed that a coronavirus vaccine, when there is one, will contain 'nanotechnology microchips' that would in theory allow humans to be controlled."],
  ['Hello friends, this is pastor Artur Pawlowksi. If you\'re watching this video, it means they have successfully arrested me and I am in jail, he said, then asking for support for his legal battle ahead.'],
  ['An article shared thousands of times on social media claims that Tal Zaks, the chief medical officer of US pharma firm Moderna, said messenger RNA vaccines can "alter" human DNA. The posts, which circulated online as Moderna’s mRNA Covid-19 vaccine was administered to millions of people around the world, claim Zaks made the comments during a TEDx Talk. The claim is false: Zaks did not make the purported comments. Scientists have previously rejected false claims that mRNA vaccines can alter DNA.
  “Bombshell: Moderna Chief Medical Officer Admits MRNA Alters DNA,” reads the screenshot of an article shared on Twitter on March 20, 2021.
  The post links to an article on US website DC Dirty Laundry.']
]

image_url = [
  'https://scopeblog.stanford.edu/wp-content/uploads/2020/12/Vaccine-story-for-Blog-Bruce-1152x578.jpeg',
  'https://media-cldnry.s-nbcnews.com/image/upload/newscms/2018_31/2520081/180804-qanon-2-al-1515-2520081.jpg',
  'https://www.theprogress.com/wp-content/uploads/2020/12/23761921_web1_201228-CPL-TOPSTORIES-WrapUp-Paul-2020_1.jpg',
  'https://c.ndtvimg.com/2020-02/327skdeg_mike-hudges_625x300_24_February_20.jpg',
  'https://specials-images.forbesimg.com/imageserve/5f8721ce19c279aa96859662/960x0.jpg?cropX1=1074&cropX2=6553&cropY1=0&cropY2=3083',
  'https://images.idgesg.net/images/article/2020/09/swatting_swat-team_raid_police_by-onfokus-getty-images-100856787-large.jpg',
  'https://image.cnbcfm.com/api/v1/image/106839139-16130497352021-02-11t023837z_615145576_rc22ql9gyycy_rtrmadp_0_health-coronavirus-usa.jpeg?v=1613049772&w=1600&h=900'
]

categories = %w[Science Aliens Covid Illuminati Politics Hollywood]

themes = %w[Science Aliens Covid Trump Cats CIA Singles]

puts 'Creating journalist...'
journalist = User.create(email: 'mrfake@fakenews.com', password: 'password', password_confirmation: 'password',
                         first_name: 'Mr.', last_name: 'Fake', role: 5)

puts 'Creating subscriber...'
subscriber = User.create(email: 'subscriber@gmail.com', password: 'password', password_confirmation: 'password',
                         first_name: 'Bob', last_name: 'Kramer', role: 2)

puts 'Creating editor....'
editor = User.create(email: 'editor@gmail.com', password: 'password', password_confirmation: 'password',
                     first_name: 'Sam', last_name: 'Kramer', role: 10)

puts 'Creating articles...'
(0...titles.count).each do |i|
  article = Article.create(title: titles[i], teaser: teasers[i], body: body[i],
                           category: categories[rand(categories.count - 1)], user_id: journalist.id, premium: [true, false].sample)
  Rating.create(user_id: journalist.id, article_id: article.id, rating: 3)
end

puts 'Attaching images to articles...'
Article.all.each_with_index do |article, index|
  file = URI.open(image_url[index])

  article.image.attach(io: file, filename: 'article_image.jpg', content_type: 'image/jpg')
end

puts 'Creating backyard articles...'
(0...titles.count).each do |i|
  backyard_article = Article.create(title: titles[i], body: body[i], backyard: true, location: %w[Sweden Denmark].sample,
                                    theme: themes[i], user_id: subscriber.id)
end
