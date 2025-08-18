# config/initializers/elasticsearch.rb

# Load configuration based on environment
config_file = Rails.root.join('config', 'elasticsearch.yml')
es_config = YAML.load_file(config_file)[Rails.env]

# Configure the default client
Elasticsearch::Model.client = Elasticsearch::Client.new(es_config)
