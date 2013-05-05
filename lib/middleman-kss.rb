require 'middleman-core'
require 'middleman-kss/version'

::Middleman::Extensions.register(:kss) do
  require 'middleman-kss/extension'
  ::Middleman::KSS
end
