class CryptoSearchCli::Coin
    @@all = []

    def self.all
        @@all
    end

    ##### COIN CREATION #####
    def initialize(hash)
        self.add_attributes(hash)
        self.class.all << self
    end

    def add_attributes(attribute_hash)
        attribute_hash.each do |attr, value|
            self.class.attr_accessor(attr)
            self.send(("#{attr}="), value)
        end
    end


    ##### COIN SEARCHING #####
    # Takes in a string, searches for a symbol that matches a coin object symbol and returns it, if not found,
    # searches for a coin object name that matches and returns it, else, returns nil
    def self.find_by_symbol_or_name(input)
        self.all.detect{|i| i.symbol.downcase == input.downcase} || self.all.detect{|i| i.name.downcase == input.downcase}
    end

    def open_in_browser
        system("open '#{self.links["homepage"][0]}'")
    end



    ##### NUMBER FORMATTING #####
    # Takes in a currency code and number string, and formats it with currency symbol, commas and decimals
    def format_currency(currency, amount)
        amount = "0" if amount.to_f < 0.01 && amount.to_f > 0.00
        Monetize.parse("#{currency} #{amount}").format
    end

    # Correctly formats large number strings with commas and decimals
    def format_number(number)
        whole, decimal = number.to_s.split('.')
        whole.reverse!.gsub!(/(\d{3})(?=\d)/, '\\1,').reverse! if whole.to_i < -999 || whole.to_i > 999
        [whole, decimal].compact.join('.')
    end


    ##### DATA DISPLAYS #####
    def display_current_price 
        puts "         ------------------------------------"
        puts Rainbow("            Current price for #{self.name}:").bright
        puts Rainbow("               +*+*+*+*+*").bright
        puts Rainbow("             #{format_currency("USD", "#{CryptoSearchCli::MarketScraper.get_price(self).values[0]}")} USD").bright
        puts Rainbow("               +*+*+*+*+*").bright
        puts "         ------------------------------------" 
    end

    def display_developer_stats
        puts "-------------------------------------------"
        puts "  Homepage:        #{self.links["homepage"][0]}"
        puts "  Developer Score:                    #{format_number("#{self.developer_score}")}"
        puts "  Community Score:                    #{format_number("#{self.community_score}")}"
        puts "  Forks:                              #{format_number("#{self.developer_data["forks"]}")}"
        puts "  Subscribers:                        #{format_number("#{self.developer_data["subscribers"]}")}"
        puts "  Total Issues:                       #{format_number("#{self.developer_data["total_issues"]}")}"
        puts "  Closed Issues:                      #{format_number("#{self.developer_data["closed_issues"]}")}"
        puts "  Merged Pull Requests:               #{format_number("#{self.developer_data["pull_requests_merged"]}")}"
        puts "  Pull Request Contributors:          #{format_number("#{self.developer_data["pull_request_contributors"]}")}"
        puts "  Code Additions Over Last 4 Weeks:   #{format_number("#{self.developer_data["code_additions_deletions_4_weeks"]["additions"]}")}"
        puts "  Code Deletions Over Last 4 Weeks:   #{format_number("#{self.developer_data["code_additions_deletions_4_weeks"]["deletions"]}")}"
        puts "  Commit Count Over Last 4 Weeks:     #{format_number("#{self.developer_data["commit_count_4_weeks"]}")}"
        puts "-------------------------------------------"
    end

    def display_market_stats(cur)
        puts "-------------------------------------------"
        puts "      **Prices shown in #{cur.upcase}**"
        puts "  Current Price:                      #{format_currency("#{cur.upcase}", "#{self.market_data["current_price"]["#{cur}"]}")}"
        puts "  Market Cap:                         #{format_currency("#{cur.upcase}", "#{self.market_data["market_cap"]["#{cur}"]}")}"
        puts "  Market Cap Rank:                    #{self.market_data["market_cap_rank"]}"
        puts "  Total Supply:                       #{format_number("#{self.market_data["total_supply"]}")}"
        puts "  Circulating Supply:                 #{format_number("#{self.market_data["circulating_supply"]}")}"
        puts "  Liquidity Score:                    #{format_number("#{self.liquidity_score}")}"
        puts "  Fully Diluted Valuation:            #{format_currency("#{cur.upcase}", "#{self.market_data["fully_diluted_valuation"]["#{cur}"]}")}"
        puts "-------------------------------------------"
    end

    def display_historical_stats(cur)
        puts "-------------------------------------------"
        puts "      **Prices shown in #{cur.upcase}**"    
        puts "  Current Price:                      #{format_currency("#{cur.upcase}", "#{self.market_data["current_price"]["#{cur}"]}")}"
        puts "  24 Hour Price Change:               #{format_currency("#{cur.upcase}", "#{self.market_data["price_change_24h_in_currency"]["#{cur}"]}")}"
        puts "  24-Hour Price Change Percentage:    #{self.market_data["price_change_percentage_24h_in_currency"]["#{cur}"]}%"
        puts "  1-Hour Price Change Percentage:     #{self.market_data["price_change_percentage_1h_in_currency"]["#{cur}"]}%"
        puts "  7-Day Price Change Percentage:      #{self.market_data["price_change_percentage_7d_in_currency"]["#{cur}"]}%"
        puts "  14-Day Price Change Percentage:     #{self.market_data["price_change_percentage_14d_in_currency"]["#{cur}"]}%"
        puts "  30-Day Price Change Percentage:     #{self.market_data["price_change_percentage_30d_in_currency"]["#{cur}"]}%"
        puts "  60-Day Price Change Percentage:     #{self.market_data["price_change_percentage_60d_in_currency"]["#{cur}"]}%"
        puts "  1-Year Price Change Percentage:     #{self.market_data["price_change_percentage_1y_in_currency"]["#{cur}"]}%"
        puts "  All Time High:                      #{format_currency("#{cur.upcase}", "#{self.market_data["ath"]["#{cur}"]}")}"
        puts "  Date of All Time High:              #{Date.parse(self.market_data["ath_date"]["#{cur}"])}"
        puts "  All Time Low:                       #{format_currency("#{cur.upcase}", "#{self.market_data["atl"]["#{cur}"]}")}"
        puts "  Date of All Time Low:               #{Date.parse(self.market_data["atl_date"]["#{cur}"])}"
        puts "-------------------------------------------"
    end
end
