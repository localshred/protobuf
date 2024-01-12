source 'https://rubygems.org'

gemspec

group :development do
  # debuggers only work in MRI
  if RUBY_ENGINE.to_sym == :ruby
    if RUBY_VERSION < '2.0.0'
      gem 'pry-debugger'
    elsif RUBY_VERSION < '2.4.0'
      gem 'pry', '~> 0.12.0'
      gem 'pry-byebug'
    else
      gem 'pry', '~> 0.13.0'
      gem 'pry-byebug', '~> 3.9.0'
    end

    gem 'pry-stack_explorer'

    gem 'ruby-prof'
    gem 'varint'
  elsif RUBY_PLATFORM =~ /java/i
    gem 'fast_blank_java'
    gem 'pry'
  end
end
