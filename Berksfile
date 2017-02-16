source 'https://supermarket.chef.io'

if Chef::VERSION.to_f < 12.0
  cookbook 'apt', '< 4.0'
  cookbook 'build-essential', '< 3.0'
  cookbook 'ohai', '< 4.0'
elsif Chef::VERSION.to_f < 12.5
  cookbook 'apt', '< 6.0'
  cookbook 'build-essential', '< 8.0'
end

metadata
