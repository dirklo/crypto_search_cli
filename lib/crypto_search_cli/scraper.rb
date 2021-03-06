class CryptoSearchCli::MarketScraper

    # Takes in a url, requests and returns the parsed JSON data
    def self.json_helper(url)
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)
    end


    ##### COIN OBJECT CREATORS #####

    # Returns a hash of all cryptocurrencies
    def self.get_coins 
        url = 'https://api.coingecko.com/api/v3/coins/list'
    
        self.json_helper(url)
    end

    # Creates coin objects, assigning their name, id, and symbol for searching purposes
    def self.make_coins
        self.get_coins.each do |coin_attributes|
            CryptoSearchCli::Coin.new(coin_attributes)
        end
    end

    
    ##### COIN DATA RETRIEVERS #####

    # Returns a the current value of passed coin
    def self.get_price(coin)
        url = "https://api.coingecko.com/api/v3/simple/price?ids=#{coin.id}&vs_currencies=USD"

        self.json_helper(url).values[0]
    end

    # Returns a hash with all extended data of passed coin 
    def self.get_extended_data(coin)
        url = "https://api.coingecko.com/api/v3/coins/#{coin.id}?localization=false&tickers=true&market_data=true&community_data=true&developer_data=true&sparkline=false"

        self.json_helper(url)
    end

    # Returns an array of arrays with 2 elements each, the title and symbol of a coin
    def self.get_top_list
        puts "SCRAPING LIST"
        url = "https://coinmarketcap.com/all/views/all/"
        html = Nokogiri::HTML(open(url))

        titles_and_symbols = html.css('.cmc-table-row').collect do |row|
            title = row.css('.cmc-link').first.attributes["title"].value
            symbol = row.css(".cmc-table__cell--sort-by__symbol div").text
            [title, symbol]
        end
    end
end
