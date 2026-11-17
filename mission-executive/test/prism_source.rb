# Reads hand-written PRISM models for the tests.
module PrismSource
  # PRISM source with each renamed module ("module B = A[x=y] endmodule")
  # written out; A may itself be a renamed module declared earlier.
  def expand(source)
    renamed = /^module (?<name>\w+) = (?<base>\w+)\[(?<renames>.*?)\] endmodule/

    while (match = source.match(renamed))
      renames = match[:renames].split(',').to_h { |rename| rename.strip.split('=') }
      body = source[/^module #{match[:base]}$(.*?^endmodule)/m, 1]
      source = source.sub(renamed) { "module #{match[:name]}#{body.gsub(/\w+/) { |word| renames.fetch(word, word) }}" }
    end

    source
  end
end
