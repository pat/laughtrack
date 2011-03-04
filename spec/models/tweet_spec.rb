require 'spec_helper'

describe Tweet do
  context 'auto-classification' do
    [ 'Tommy tiernan was very funny',
      'Frank Woodley at the Powerhouse ... performances brilliant.',
      'Hannah Gadsby Five stars',
      'Ross Noble is the funniest man I have ever seen!',
      'ross noble is sooooo funny',
      'The Axis of Awesome is AMAZING',
      'the Small Poppies have much inspired silly satire. Worth a watch',
      'Gala was awesome',
      'Julian Clary may be crude.. But its Hilarious',
      "Go see Eric's Tales of the Sea at #adlfringe. It's a real gem.",
      'Nina Conti is a fantastic performer. Very talented and funny.',
      'following melinda buttle now? good. she is bloody hilarious.',
      'Rich Fulcher has got to be one of the funniest men alive.',
      'Saw Adam Hills at the Fringe Festival tonight and loved his show',
      'OMFG I LOVE DENISE SCOTT!!! she is the funniest ever!',
      'Philip Escoffey last night was incredible',
      'Nina Conti was bloody fantastic! Loved her new set',
      '... the Pajama Men. An absolute delight.'
    ].each do |phrase|
      it "should mark \"#{phrase}\" as positive" do
        Tweet.make!(:text => phrase).classification.should == 'positive'
      end
    end
    
    [ 'Akmal is not very funny',
      'Jason Byrne, he was a complete twat',
      "i'm not a fan of jason byrne."
    ].each do |phrase|
      it "should mark \"#{phrase}\" as negative" do
        Tweet.make!(:text => phrase).classification.should == 'negative'
      end
    end
  end
  
  context 'auto-ignore' do
    [ 'Goal: Jason Byrne - 32 - Bohemians - http://www.worldsoccertweets.com',
      "BBC - BBC Comedy Blog: Sarah Millican's Support Group",
      "RT @ComedyChannel: AUSTRALIA'S FUNNIEST - Comedy Festival",
      "@dhughesy RT @PeterBlackQUT i still don't know what i did",
      'I want to see this on Spicks and Specks',
      'I favorited a YouTube video -- The Axis of Awesome 4 Chords',
      'Check this video out -- The Axis of Awesome 4 Chords',
      'Watching The Bubble. I really like Josie Long.',
      'I just heard that Henry Rollins was on Rupauls Drag Race.',
      'I rated a YouTube video',
      'Colin Lane is hilarious #spicks&specks',
      '#nowplaying The Bedroom Philosopher – Northcote (So Hungover)',
      'Jeff Green left a comment for Kay Clover',
      'Green able to play Friday: Oklahoma City Jeff Green scored 25 points',
      'Jason Coleman on The 7pm Project',
      'Nick Sun @ Station 59, 2008: http://url4.eu/1fXfN',
      'Thank god youre here - Jimeoin: http://url4.eu/1pYPg',
      'The 100 club: Artists who signed up for comedian Josie Long',
      'can you please send a autograph picture.tks n God Bless Dave Hughes',
      'Jag har favoritmarkerat ett videoklipp på YouTube',
      'I favourited a YouTube video -- The Axis of Awesome 4 Chords',
      "Josh Lawson was on Thank God Your Here",
      'Essence Festival 2010 will be on fire.',
      'Retro surfboard fun at the Hyundai Malfunction Surf Festival',
      "I'm not here for your entertainment",
      'Win free tickets to over 75 #MICF shows',
      "This is the Tom Green show. It's not the Green Tom show.",
    ].each do |phrase|
      it "should mark \"#{phrase}\" as ignored" do
        Tweet.make!(:text => phrase, :autoignore => true).should be_ignored
      end
    end
    
    [ 'Colin Lane is hilarious #spicks&specks #laughtrack',
      'Colin Lane is hilarious #spicks&specks #micf',
      '@laughtrack_au Frank Woodley hit and miss. Sheer genius at times'
    ].each do |phrase|
      it "should mark \"#{phrase}\" as not ignored" do
        Tweet.make(:text => phrase, :autoignore => true).should_not be_ignored
      end
    end
  end
end
