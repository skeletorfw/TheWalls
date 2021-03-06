
require 'squib'
# require 'game_icons'

buildstring = Time.now.strftime('%d%m%y%H%M')   # Create buildstring
pdfgen = true
state = 'Alpha'
tcgrun = true

if tcgrun
  data = Squib.csv file: 'TheWallsConcept_gcready.csv'
  pdfgen = false
else
  data = Squib.csv file: 'TheWallsConcept.csv'
end

Squib::Deck.new cards: data['Title'].size, layout: 'layout.yml' do
  background color: 'white'
  rect layout: 'cut' # cut line as defined by TheGameCrafter - poker cards
  rect layout: 'safe' # safe zone as defined by TheGameCrafter
  text str: data['Title'], layout: 'title'
  text str: data['Type'], layout: 'type'
  svg file: data['Svgpath'], layout: 'art'
  text str: data['Effect'], layout: 'effect'
  text str: data['Description'], layout: 'description'
  text str: data['Details'], layout: 'details'

  # Only add build details on non-prod runs
  if state != 'Production'
    text str: "#{state} build #{buildstring}", layout: 'copyright'
  end

  # Build cards
  save_png dir: "testdecks/build_#{buildstring}"
  if pdfgen
    save_pdf file: "thewalls_build_#{buildstring}.pdf", dir: "testdecks/build_#{buildstring}", trim: 37.5
  end
end
