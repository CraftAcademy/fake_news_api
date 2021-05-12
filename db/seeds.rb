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

for i in 0...titles.count
  Article.create(title: titles[i], teaser: teasers[i])
end