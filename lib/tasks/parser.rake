task :parse,[:count] => :environment do |t,args|
    ParseArticleJob.perform_later args[:count]
    
end