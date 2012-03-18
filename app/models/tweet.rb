class Tweet < ActiveRecord::Base
  IMPORT_URL = 'http://search.twitter.com/search.json'

  belongs_to :show
  belongs_to :user

  attr_accessor :json

  before_validation :set_from_json, :on => :create

  validates :tweet_id, :uniqueness => true, :unless => :show_id?

  scope :pending,      where(:ignore => false, :confirmed => false)
  scope :unclassified, where(:confirmed => true, :classification => nil)
  scope :detached,     where('classification IS NOT NULL and show_id IS NULL')

  def self.import!
    params = {:rpp => 100, :q => '#micf'}.to_query
    json = Nestful.get "#{IMPORT_URL}?#{params}", :format => :json,
      :headers => {'User-Agent' => 'laughtrack.com.au'}

    json['results'].select { |tweet|
      create(:json => tweet).persisted?
    }.length
  end

  def attach_to(show_id)
    update_attribute :show_id, show_id
  end

  def confirm!
    update_attribute :confirmed, true
  end

  def ignore!
    update_attribute :ignore, true
  end

  def linked_text
    text.
      gsub(/@(\w+)/, %Q{<a href="http://twitter.com/\\1" class="twitter_name" target="_blank">@\\1</a>}).
      gsub(/#(\w+)/, %Q{<a href="http://search.twitter.com/search?q=\\1" class="twitter_hash" target="_blank">#\\1</a>}).html_safe
  end

  def negative!
    update_attribute :classification, 'negative'
  end

  def positive!
    update_attribute :classification, 'positive'
  end

  private

  def set_from_json
    return if json.nil?

    self.tweet_id          = json['id_str']
    self.to_user_id        = json['to_user_id_str'] ||
                             json['in_reply_to_user_id_str']
    self.from_user_id      = json['from_user_id_str'] ||
                             json['user']['id_str']
    self.profile_image_url = json['profile_image_url'] ||
                             json['user']['profile_image_url']
    self.source            = json['source']
    self.text              = json['text']
    self.from_user         = json['from_user'] ||
                             json['user']['screen_name']
    self.raw               = json.to_s
    self.created_at        = json['created_at']
  end
end
