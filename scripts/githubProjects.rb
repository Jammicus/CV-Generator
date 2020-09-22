require 'faraday'
require 'json'
require 'httpclient'

githubKey = ARGV[0]
# https://www.rubyguides.com/2018/08/ruby-http-request/
githubUrl='https://api.github.com/users/jammicus/repos'
excludedRepositories=['BrewFile', 'convert-to-pipeline-plugin',
                      'chefspec', 'etcd', 'go-misc', 'jammicus.github.io',
                      'Miscellaneous', 'packtpub-free-book-clicker', 
                      'Python-Crash-Course-Exercises', 'CurrencyRates', 'crontib',
                        'opentelemetry-collector-contrib', 'charts', 'helm', 'go-misc',
                        'contrib' ]

conn = Faraday.new(:url => githubUrl) do |faraday|
    # uncomment this to get log the return of the request to the command line
    faraday.adapter :httpclient do |client|
        client.keep_alive_timeout = 20
        client.ssl_config.timeout = 25
    end
end

resp = conn.get do |req|
    req.headers['Accept'] = 'application/vnd.github.inertia-preview+json'
    req.headers['Authorization'] = "token #{githubKey}"
end

contents = JSON.parse(resp.body)

contents.each do |item|
    if (!excludedRepositories.include? item["name"]) && (item["fork"] != true)
        puts "* " + item["name"] + " - " + item ["description"]
    end
end