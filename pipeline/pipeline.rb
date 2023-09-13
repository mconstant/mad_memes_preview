require 'bundler'
require 'json'
require 'dotenv/load'

Bundler.require

Pinata.api_key = ENV["PINATA_API_KEY"]
Pinata.secret_api_key = ENV["PINATA_SECRET_KEY"]

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



nft_json = nfts.map.each_with_index do |nft, idx|
  {id: idx+1, name: "Mad Meme ##{idx+1}", image: nft["Attachments"], rarity_number: nft["Rarity Number"], rareness_class: nft["Rareness Class"]}
end

File.open("../vite-project/nfts.json", "w+") do |f|
  f.write(JSON.pretty_generate(nft_json))
end

resp = Pinata::Pin.pin_file('../vite-project/nfts.json')

puts resp

puts "Link to uploaded File https://magenta-uninterested-barnacle-460.mypinata.cloud/ipfs/#{resp["IpfsHash"]}"