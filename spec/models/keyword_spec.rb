require 'spec_helper'

describe Keyword do
  describe '.import_oldest' do
    it "should request just 60 keywords" do
      Keyword.should_receive(:find) do |mode, options|
        options[:limit].should == 60
        []
      end
      
      Keyword.import_oldest
    end
    
    it "should order by imported_at ascending" do
      Keyword.should_receive(:find) do |mode, options|
        options[:order].should == 'imported_at ASC'
        []
      end
      
      Keyword.import_oldest
    end
    
    it "should call import on each keyword returned" do
      keywords = (1..10).collect { |i|
        stub('keyword').as_null_object
      }
      keywords.each { |k| k.should_receive(:import) }
      Keyword.stub!(:find => keywords)
      
      Keyword.import_oldest
    end
  end
  
  describe '#valid?' do
    it "should be invalid without a show" do
      keyword = Keyword.make :show => nil
      keyword.should have(1).error_on(:show)
    end
    
    it "should be invalid without any words" do
      keyword = Keyword.make :words => nil
      keyword.should have(1).error_on(:words)
    end
  end
  
  describe '#import' do
    before :each do
      @database = stub('database', :function => []).as_null_object
      Throne::Database.stub!(:new => @database)
      
      FakeWeb.register_uri :get, /search\.twitter\.com/,
        :body => '{"results":[{"text":"foo","id":"bar"}]}'
        
      @keyword = Keyword.make!
    end
    
    it "should load the twitter search results" do
      @keyword.import
      
      FakeWeb.should have_requested(:get, /search\.twitter\.com/)
    end
    
    it "should add the tweet to CouchDB" do
      @database.should_receive(:save) do |hash|
        hash['text'].should == 'foo'
        hash['id'].should == 'bar'
      end
      
      @keyword.import
    end
    
    it "should not add the tweet to CouchDB if it already exists" do
      @database.should_not_receive(:save)
      @database.stub!(:function => ['foo'])
      
      @keyword.import
    end
    
    it "should set the show id for the tweet" do
      @database.should_receive(:save) do |hash|
        hash[:show_id].should == @keyword.show_id
      end
      
      @keyword.import
    end
    
    it "should update the imported_at time" do
      @keyword.imported_at = 3.day.ago
      
      @keyword.import
      
      @keyword.imported_at.to_date.should == Date.today
    end
    
    it "should not check for shows that have not happened" do
      @keyword.show.performances.create(:happens_at => 3.days.from_now)
      @keyword.import
      
      FakeWeb.should_not have_requested(:get, /search\.twitter\.com/)
    end
    
    it "should not check for shows that finished five days ago" do
      @keyword.show.performances.create(:happens_at => 6.days.ago)
      @keyword.import
      
      FakeWeb.should_not have_requested(:get, /search\.twitter\.com/)
    end
    
    it "should check for shows that finished four days ago" do
      @keyword.show.performances.create(:happens_at => 4.days.ago)
      @keyword.import
      
      FakeWeb.should have_requested(:get, /search\.twitter\.com/)
    end
    
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
          FakeWeb.register_uri :get, /search\.twitter\.com/,
            :body => "{\"results\":[{\"text\":\"#{phrase}\",\"id\":\"bar\"}]}"
          
          @database.should_receive(:save) do |hash|
            hash[:classification].should == 'positive'
          end
          
          @keyword.import
        end
      end
      
      [ 'Akmal is not very funny',
        'Jason Byrne, he was a complete twat',
        "i'm not a fan of jason byrne."
      ].each do |phrase|
        it "should mark \"#{phrase}\" as negative" do
          FakeWeb.register_uri :get, /search\.twitter\.com/,
            :body => "{\"results\":[{\"text\":\"#{phrase}\",\"id\":\"bar\"}]}"
          
          @database.should_receive(:save) do |hash|
            hash[:classification].should == 'negative'
          end
          
          @keyword.import
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
          FakeWeb.register_uri :get, /search\.twitter\.com/,
            :body => "{\"results\":[{\"text\":\"#{phrase}\",\"id\":\"bar\"}]}"
          
          @database.should_receive(:save) do |hash|
            hash[:ignore].should be_true
          end
          
          @keyword.import
        end
      end
      
      [ 'Colin Lane is hilarious #spicks&specks #laughtrack',
        'Colin Lane is hilarious #spicks&specks #micf',
        '@laughtrack_au Frank Woodley hit and miss. Sheer genius at times'
      ].each do |phrase|
        it "should mark \"#{phrase}\" as not ignored" do
          FakeWeb.register_uri :get, /search\.twitter\.com/,
            :body => "{\"results\":[{\"text\":\"#{phrase}\",\"id\":\"bar\"}]}"
          
          @database.should_receive(:save) do |hash|
            hash[:ignore].should be_false
          end
          
          @keyword.import
        end
      end
    end
  end
end
