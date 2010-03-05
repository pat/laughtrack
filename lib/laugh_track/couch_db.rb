module LaughTrack::CouchDb
  private
  
  def db
    @db ||= Throne::Database.new 'http://127.0.0.1:5984/laughtrack', false
  end
end
