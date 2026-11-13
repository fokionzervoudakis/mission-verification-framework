default:
    @just --list

# Install dependencies
[group('setup')]
install:
    @brew install ruby
    @brew install swi-prolog
    @bundle install

# Run all tasks
[group('dev')]
run: validate execute generate classify parse

# Validate mission plans
[group('dev')]
validate:
    #!/usr/bin/env bash
    set -euo pipefail
    cd mission-executive/operations/
    # kwalify exits 0 for a plan that breaks the schema
    find . -name 'operation_*' -exec bundle exec kwalify -lf schema.yaml {} + |
        awk '{ print } /INVALID/ { invalid = 1 } END { exit invalid }'

# Execute individual mission plans
[group('dev')]
execute:
    @cd mission-executive/ && ./mission.rb

# Lint sources
[group('dev')]
lint:
    @bundle exec rubocop

# Test the mission executive
[group('dev')]
test:
    @cd mission-executive/ && ruby -e 'Dir["./test/*_test.rb"].each { |file| require file }'

# Generate PRISM DTMC/PCTL code from templates
[group('dev')]
generate:
    @cd mission-executive/ && \
        ./asset_template.rb && \
        ./survivability_template.rb && \
        ./property_template.rb

# Use SWI-Prolog to classify UAV mission elements
[group('dev')]
classify:
    @cd prolog-kb/ && \
        find . -name 'operation_*' | sort | xargs -I {} swipl --on-error=status -q -s {} -t halt

# Execute the parser
[group('dev')]
parse:
    @cd parser/ && ./parser.rb && ./metrics.rb
