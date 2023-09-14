require 'bundler'
require 'json'
require 'dotenv/load'

Bundler.require
include HTTParty

cids = JSON.parse(`curl -G -d "limit=1000" -H "Authorization: Bearer #{ENV['NFT_STORAGE_KEY']}" https://api.nft.storage/`)["value"].map {|entry| entry["cid"]}
cids.each do |cid|
    puts `curl -X DELETE -H "Authorization: Bearer #{ENV['NFT_STORAGE_KEY']}" https://api.nft.storage/#{cid}`
    sleep 1
end