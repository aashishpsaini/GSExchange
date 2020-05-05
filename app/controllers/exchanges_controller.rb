class ExchangesController < ApplicationController
	before_action :set_sellers
	
	def create
		render( 
			status: 422,
			json: 'Faulty params'
		) && return if exchanges_params.empty?

		render(
			json: result,
			status: 200
		)
	end

  private

	def result
		perform_exchange
	end

  def set_sellers
    @sellers = JSON.parse(File.read("#{Rails.root}/db/sellers.json"))
  end

	def exchanges_params
		params.permit(buyer:{}).to_h
	end

  def perform_exchange
		buyer = exchanges_params['buyer']

		return @sellers.push(buyer).to_json unless @sellers.select {|s| s['rate'] <= buyer['rate']}.present?

		@sellers = @sellers.sort_by {|seller| seller['rate']}

		@sellers.each do |seller|
			if(buyer['rate'] >= seller['rate'])
				if(buyer['amount'] >= seller['amount_available'])
					buyer['amount'] = buyer['amount'] - seller['amount_available']
					seller['amount_available'] = 0
				else
					seller['amount_available'] = seller['amount_available'] - buyer['amount']
					buyer['amount'] = 0
					return @sellers
				end
			else
				@sellers.push(buyer).to_json
			end

		end
		@sellers
	end
end
