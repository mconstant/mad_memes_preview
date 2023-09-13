require 'bundler'
require 'json'
require 'dotenv/load'

Bundler.require
include HTTParty

nft_storage_api_endpoint="https://api.nft.storage/upload"

# Pinata.api_key = ENV["PINATA_API_KEY"]
# Pinata.secret_api_key = ENV["PINATA_SECRET_KEY"]

puts "getting Google Drive Session"
begin
  session = GoogleDrive::Session.from_service_account_key("google_sheets.json")
rescue Exception => e
  puts e.backtrace.join("\n")
end

puts "Loading Spreadsheet"

spreadsheet = session.spreadsheet_by_title("madmemes0")
puts "Loading Worksheet"
worksheet = spreadsheet.worksheets[0]
puts worksheet.title

nfts = []
headers = worksheet.rows[0]
num_rows = worksheet.num_rows
(2..(num_rows)).each do |row_index|
  begin
    hsh={}
    headers.each.with_index do |header, idx|
      
        hsh[header] = worksheet.input_value(row_index, idx + 1)
      
    end
    
    
    hsh["Attachments"] = hsh["Attachments"].match(/IMAGE\(\"(.+)\"/)[1]

    nfts << hsh

  rescue
    puts "problem with row #{row_index}"
  end

end

nfts = nfts.reject do |nft|
  extension = nft["Attachments"].split('.').last.chomp
  puts "Reject extension is #{extension}"
  (extension == "mp4") || (extension == "webm")
end

nft_json = nfts.map.each_with_index do |nft, idx|
  {id: idx+1, name: "Mad Meme ##{idx+1}", image: nft["Attachments"], rarity_number: nft["Rarity Number"], rareness_class: nft["Rareness Class"]}
end

File.open("../vite-project/nfts.json", "w+") do |f|
  f.write(JSON.pretty_generate(nft_json))
end

nft_json = nfts.map.each_with_index do |nft, idx|
  url = `cat ../vite-project/nfts.json | jq -r .[#{idx}].image`
  extension = url.split('.').last.chomp
  cmd = "curl #{url.chomp} --output memes_raw/meme_#{idx+1}.#{extension}"
  `#{cmd}`
  # `curl #{url} --output memes_raw/meme_#{idx+1}.#{extension}`
  #`curl $(cat nfts.json | jq -r .[${idx}].image) -O memes_raw/meme_1.`
  #{id: idx+1, name: "Mad Meme ##{idx+1}", image: nft["Attachments"], rarity_number: nft["Rarity Number"], rareness_class: nft["Rareness Class"]}
  puts "attempting to label, resize and frame memes_raw/meme_#{idx+1}.#{extension}"
  cmd2 = "./frame.sh memes_raw/meme_#{idx+1}.#{extension} DejaVu-Sans 24 \"Mad Meme ##{idx+1}: #{nft['Rareness Class']}\" frame.png memes_processed/meme_#{idx+1}_season_1.#{extension}"
  # puts cmd2
  `#{cmd2}`
  cid = `curl -s -F file=@memes_processed/meme_#{idx+1}_season_1.#{extension} -H "Authorization: Bearer #{ENV['NFT_STORAGE_KEY']}" https://api.nft.storage/upload | jq -r .value.cid`.chomp
  nft_storage_link = "https://ipfs.io/ipfs/#{cid}/meme_#{idx+1}_season_1.#{extension}"
  puts "Link to uploaded image file on ipfs #{nft_storage_link}"
  if nft_storage_link
    {id: idx+1, name: "Mad Meme ##{idx+1}", image: nft_storage_link, rarity_number: nft["Rarity Number"], rareness_class: nft["Rareness Class"]}
  else
    File.open("imagemagick_errors.log", "a") do |f|
      f.puts "Error processing #{nft["Attachments"]}"
    end
    {id: idx+1, name: "Mad Meme ##{idx+1}", image: nft["Attachments"], rarity_number: nft["Rarity Number"], rareness_class: nft["Rareness Class"]}
  end
end

File.open("../vite-project/nfts.json", "w+") do |f|
  f.write(JSON.pretty_generate(nft_json))
end

resp = Pinata::Pin.pin_file('../vite-project/nfts.json')

puts resp

puts "Link to uploaded File https://magenta-uninterested-barnacle-460.mypinata.cloud/ipfs/#{resp["IpfsHash"]}"