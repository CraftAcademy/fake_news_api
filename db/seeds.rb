titles = [
  'New Vaccine Conspiracy Theories Are Going Viral in Arabic',
  '‘It is a trap!’: Inside the QAnon attack that never happened',
  'New Year 2020: 10 Moments This Decade That Made Us Say, "Wait, What?"',
"Amateur Rocket-Maker Finally Launches Himself Off Earth - Now To Prove It's Flat"
]
teasers = [
  'Facebook has been criticized for failing to curb misinformation in English. But little attention has been paid to the scale of the problem in Arabic.',
'Why fears of violence on March 4, the mythical day Trump was supposed to be inaugurated to a second term, proved unfounded.',
'Happy New Year 2020: This list of ten moments includes not just personalities in India and across the world, but also certain events which have had a number of consequences for those involved.',
'Mike Hughes, a California man who is most known for his belief that the Earth is shaped like a Frisbee, finally blasted off into the sky in a steam-powered rocket he had built himself.'
]

body =
  'Science gets a lot of respect these days. Unfortunately, it’s also getting a lot of competition from misinformation. Seven in 10 Americans think the benefits from science outweigh the harms, and nine in 10 think science and technology will create more opportunities for future generations. Scientists have made dramatic progress in understanding the universe and the mechanisms of biology, and advances in computation benefit all fields of science.
  On the other hand, Americans are surrounded by a rising tide of misinformation and fake science. Take climate change. Scientists are in almost complete agreement that people are the primary cause of global warming. Yet polls show that a third of the public disagrees with this conclusion.
  
  In my 30 years of studying and promoting scientific literacy, I’ve found that college educated adults have large holes in their basic science knowledge and they’re disconcertingly susceptible to superstition and beliefs that aren’t based on any evidence. One way to counter this is to make it easier for people to detect pseudoscience online. To this end, my lab at the University of Arizona has developed an artificial intelligence-based pseudoscience detector that we plan to freely release as a web browser extension and smart phone app.'

categories = ['Flat Earth', 'Aliens', 'Covid', 'Illuminati', 'Politics', 'Hollywood']

user = User.create(email: 'mrfake@fakenews.com', password: 'password', password_confirmation: 'password', first_name: 'Mr.', last_name: 'Fake', role: 5)

for i in 0...titles.count
  Article.create(title: titles[i], teaser: teasers[i], body: body, category: categories[rand(categories.count-1)], user_id: user.id)
end 