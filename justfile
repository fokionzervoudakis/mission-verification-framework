BOLD := `printf "\033[1m"`
RED := `printf "\033[31m"`
RESET := `printf "\033[0m"`

default:
    @just --list

# Install dependencies
[group('setup')]
install: githooks
    @brew install ruby
    @brew install swi-prolog
    @brew install betterleaks
    @bundle install

# Install Git hooks
[group('setup')]
githooks:
    @git config core.hooksPath hooks

# Update dependencies
[group('setup')]
update:
    @echo "{{RED}}{{BOLD}}Updating dependencies...{{RESET}}"
    @bundle update

# Generate PRISM DTMC/PCTL code from templates
[group('dev')]
generate:
    @echo "{{RED}}{{BOLD}}Generating PRISM code from templates...{{RESET}}"
    @cd mission-executive/ && \
        ./asset_template.rb && \
        ./survivability_template.rb && \
        ./property_template.rb

# Run tests
[group('dev')]
test:
    @echo "{{RED}}{{BOLD}}Running tests...{{RESET}}"
    @cd mission-executive/ && ruby -e 'Dir["./test/*_test.rb"].each { |file| require file }'

# Lint sources
[group('dev')]
lint:
    @echo "{{RED}}{{BOLD}}Linting sources...{{RESET}}"
    @bundle exec rubocop

# Run all tasks
[group('dev')]
run: validate execute generate classify parse

# kwalify exits 0 for a plan that breaks the schema
# Validate mission plans
[group('dev')]
validate plan="mission-executive/operations/operation_*":
    @echo "{{RED}}{{BOLD}}Validating mission plans...{{RESET}}"
    @output=$(bundle exec kwalify -lf mission-executive/operations/schema.yaml {{plan}}) && \
        printf "%s\n" "$output" && \
        ! printf "%s\n" "$output" | grep -q INVALID

# Execute individual mission plans
[group('dev')]
execute:
    @echo "{{RED}}{{BOLD}}Executing mission plans...{{RESET}}"
    @cd mission-executive/ && ./mission.rb

# Use SWI-Prolog to classify UAV mission elements
[group('dev')]
classify:
    @echo "{{RED}}{{BOLD}}Classifying mission elements...{{RESET}}"
    @cd prolog-kb/ && \
        find . -name 'operation_*' | sort | xargs -I {} swipl --on-error=status -q -s {} -t halt

# PRISM must be installed in ~/prism
# Verify the PRISM models
[group('prism')]
verify:
    @echo "{{RED}}{{BOLD}}Verifying the PRISM models...{{RESET}}"
    @cd scripts/ && PRISM=~/prism/bin/prism ./model_results.rb

# PRISM must be installed in ~/prism
# Export the states and transitions of the PRISM models
[group('prism')]
states:
    @echo "{{RED}}{{BOLD}}Exporting model states and transitions...{{RESET}}"
    @mkdir -p data/model-states
    @for model in models/*/*.pm; do \
        name=$(basename $model .pm); \
        ~/prism/bin/prism $model \
            -exportstates data/model-states/$name.sta \
            -exporttrans data/model-states/$name.tra > /dev/null || exit 1; \
    done

# Execute the parser
[group('dev')]
parse:
    @echo "{{RED}}{{BOLD}}Parsing plans and models...{{RESET}}"
    @cd parser/ && ./parser.rb && ./metrics.rb
