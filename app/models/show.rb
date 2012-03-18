require 'open-uri'

class Show < ActiveRecord::Base
  IMPORT_URL = 'http://comedy.efirst.com.au/iPhone_application/dataUpdate.asp'

  before_save :save_heading, :if => :headings_changed?

  scope :order_by_headings, order('heading ASC')

  def self.import!
    params   = {
      :lastDataUpdate => 5.months.ago.to_s(:db),
      :av             => '3.0.2'
    }.to_query

    document = Nokogiri::XML(open("#{IMPORT_URL}?#{params}"))
    document.css('dataUpdate > s').each do |session|
      heading_one = session.at('p').try(:content) || ''
      heading_two = session.at('b').try(:content) || ''

      Show.find_or_create_by_heading_one_and_heading_two(
        heading_one, heading_two)
    end
  end

  private

  def headings_changed?
    heading_one_changed? || heading_two_changed?
  end

  def save_heading
    self.heading ||= [heading_one, heading_two].reject(&:blank?).join(' ')
  end
end
