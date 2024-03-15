#!/usr/bin/env ruby

class String
  def strip_comments(marker)
    if include?(marker)
      index = (self =~ Regexp.new(marker))
      self[0, index + marker.size]
    else
      self
    end
  end
end

@dtmc_tokens = {
  comments: ['//'],
  identifiers: [/(_|[a-z])[0-9]/],
  keywords: [
    :bool,
    :const,
    :dtmc,
    :endmodule,
    # rubocop:disable Lint/BooleanSymbol
    :false, :formula,
    :init, :int,
    /mod\(/, /^module/,
    :true
    # rubocop:enable Lint/BooleanSymbol
  ],
  operators: [
    %r{[!&*+<=?|]| / },
    /(?<=[^-])>/, # greater than
    /-(?=[^>])/ # minus
  ],
  separators: [/[(),:;\['\]]|\.\.|->/],
  values: [
    /(\+|-|\.|=|= |>|\[)[0-9]/,
    /(?<=[^=]) [0-9];/
  ]
}

@pctl_tokens = {
  identifiers: [/[a-z]([0-9]|>)/],
  keywords: [:F, /mod\(/],
  operators: [:P, /[!&=>?]/],
  separators: [/[(),\[\]]/],
  values: [/(=|>)[0-9]/]
}

@yaml_tokens = {
  comments: ['#'],
  keywords: [
    /^Action/, :ARDrone, :Asset, :actions,
    :concurrencies,
    :duration,
    :HoverAction, :Hummingbird,
    /id:/, :interval,
    :LidarAction,
    :PhotoSurveillanceAction, :preconditions,
    :TraversePathSegmentAction
  ],
  separators: [/[,\-:\[\]]/],
  values: [/( |\[)-?[0-9]/]
}

def count_tokens(path, *extensions)
  extensions.each do |extension|
    Dir[path + extension.to_s].each do |file|
      tokens =
        case extension
        when :pctl
          @pctl_tokens
        when :pm
          @dtmc_tokens
        when :yaml
          @yaml_tokens
        end

      count = 0

      File.open(file).each do |line|
        line = line.strip_comments(tokens[:comments][0]) if tokens.key?(:comments)
        tokens.each_pair do |_key, value|
          value.each do |token|
            count += line.scan(token.is_a?(Symbol) ? token.to_s : token).size
          end
        end
      end

      filename = File.basename(file)
      loc = File.readlines(file).size
      puts "#{filename},loc=#{loc},tokens=#{count}"
    end
  end
end

PATH = File.dirname(__FILE__)
count_tokens("#{PATH}/../mission-executive/operations/operation_*", :yaml)
count_tokens("#{PATH}/../models/operation_**/*", :pctl, :pm)
