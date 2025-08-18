class PropertySearchService
  def self.search(query_params, company_id) # rubocop:disable Metrics/AbcSize
    search_definition = {
      query: {
        bool: {
          must: [
            { term: { company_id: company_id } }
          ],
          filter: []
        }
      }
    }

    return unless query_params[:min_price].present?

    search_definition[:query][:bool][:filter] << { range: { price: { gte: query_params[:min_price].to_f } } }

    return unless query_params[:max_price].present?

    search_definition[:query][:bool][:filter] << { range: { price: { lte: query_params[:max_price].to_f } } }

    if query_params[:property_type].present?
      search_definition[:query][:bool][:filter] << {
        term: { property_type: query_params[:property_type] }
      }
    end


    if query_params[:bedrooms_min].present?
      search_definition[:query][:bool][:filter] << {
        range: { bedrooms: { gte: query_params[:bedrooms_min].to_i } }
      }
    end

    if query_params[:bedrooms_max].present?
      search_definition[:query][:bool][:filter] << {
        range: { bedrooms: { lte: query_params[:bedrooms_max].to_i } }
      }
    end


    if query_params[:bathrooms_min].present?
      search_definition[:query][:bool][:filter] << {
        range: { bathrooms: { gte: query_params[:bathrooms_min].to_f } }
      }
    end


    if query_params[:sqft_min].present?
      search_definition[:query][:bool][:filter] << {
        range: { square_feet: { gte: query_params[:sqft_min].to_i } }
      }
    end


    if query_params[:year_built_min].present?
      search_definition[:query][:bool][:filter] << {
        range: { year_built: { gte: query_params[:year_built_min].to_i } }
      }
    end


    if query_params[:lat].present? && query_params[:lng].present? && query_params[:radius].present?
      search_definition[:query][:bool][:filter] << {
        geo_distance: {
          distance: "#{query_params[:radius].to_f}km",
          location: {
            lat: query_params[:lat].to_f,
            lon: query_params[:lng].to_f
          }
        }
      }
    end


    sort_options = []
    case query_params[:sort_by]
    when 'price_asc'
      sort_options << { price: { order: 'asc' } }
    when 'price_desc'
      sort_options << { price: { order: 'desc' } }
    when 'newest'
      sort_options << { created_at: { order: 'desc' } }

    end
    search_definition[:sort] = sort_options unless sort_options.empty?


    Property.__elasticsearch__.search(search_definition)
  end
end
