require 'bundler'
require 'json'

Bundler.require

nfts = JSON.parse(File.read("../vite-project/nfts.json"))

puts "getting Google Drive Session"
begin
  session = GoogleDrive::Session.from_service_account_key("google_sheets.json")
rescue Exception => e
  puts e.backtrace.join("\n")
end

puts "Loading Spreadsheet"

spreadsheet = session.spreadsheet_by_title("nfts")
puts "Loading Worksheet"
worksheet = spreadsheet.worksheets[0]
puts worksheet.title

puts worksheet.cells

#start at row 4
row = 3

royalty_addresses_hsh = {
  mconstant: "secret1xuprg4xkk5en00zx5lnrcg5xaxqslrhpnfguna",
  kript: "secret1xu3xe8xdre8yzgvc6kyqdeugfad8fzxp6lehfp",
  madprofessor: "secret1ru0ejl6f2y4uk9h5uyezkce337mcdrwctgm07m",
  project_treasury: "secret1g63ku6svfq8zcpvgqqn2djwm6s8lg93dtttwqd"
}

royalty_addresses_str = royalty_addresses_hsh.values.map do |address|
  share = 1.0 / royalty_addresses_hsh.keys.count
  {"address" => address, "percentage" => share.to_s}
end.to_json

puts royalty_addresses_str

nfts.first(4).each do |nft|
  image = nft["image"]
  extension = image.split('/').last.split('.').last
  worksheet[row, 1]=nft["id"]
  worksheet[row, 2]=nft["name"]
  worksheet[row, 3]=nft["name"]
  worksheet[row, 4]="meme_#{nft["id"]}_season_1.png"
  worksheet[row, 6]="meme_#{nft["id"]}_season_1.png"
  worksheet[row, 7]="[{ \"url\": \"#{image}\", \"extension\": \"#{extension}\" }]"
  worksheet[row, 8]="[ { \"name\": \"meme_id\", \"value\": \"#{nft["name"]}\"}, {\"name\": \"rarity_number\", \"value\": \"#{nft["rarity_number"]}\"}, {\"name\": \"rareness_class\", \"value\": \"#{nft["rareness_class"]}\"} ]"
  worksheet[row, 11]=royalty_addresses_str
  row += 1
end

worksheet.save