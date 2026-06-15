# CLAUDE.md

Guidance for working in this repository.

## Testing

- One `expect` per test. Each example asserts a single behavior; when you need several assertions, split them into separate `it` blocks.
- Keep each `it` block to a single line whenever possible. When a test fits on a single line, its description adds nothing — omit it and use the one-liner form. For example, prefer:

  ```ruby
  it { expect(described_class.verify_and_save(encode(solution_params))).to be_truthy }
  ```

  over:

  ```ruby
  it "returns a truthy value for a valid submission" do
    expect(described_class.verify_and_save(encode(solution_params))).to be_truthy
  end
  ```
- Declare a named `subject` in every `describe` block. For example, prefer:

  ```ruby
  describe ".verify_and_save" do
    subject(:verify_and_save) { described_class.verify_and_save(encoded) }

    it { is_expected.to be_truthy }
  end
  ```

  over:

  ```ruby
  describe ".verify_and_save" do
    it { expect(described_class.verify_and_save(encoded)).to be_truthy }
  end
  ```
- Whenever the assertion targets the `subject`, use the `is_expected` form. For example, prefer:

  ```ruby
  it { is_expected.to be_truthy }
  ```

  over:

  ```ruby
  it { expect(verify_and_save).to be_truthy }
  ```
- When a spec needs helper methods, declare them at the bottom of the file, in a `private` section. For example, prefer:

  ```ruby
  RSpec.describe DailySummary do
    subject(:summary) { described_class.new }

    it { expect(summary_kinds).to be_empty }

    private

    def summary_kinds
      summary.concerned_administrators.flat_map(&:kind)
    end
  end
  ```

  over defining the helper near the top of the example group.

## Pull requests

- Follow the project's pull request template (`.github/pull_request_template.md`): keep its sections (Description, Test plan, Review app, Links, Screenshots).
- Do not add a `Co-authored-by: Claude` trailer (or any Claude / Anthropic co-author) to commits or pull requests.
- Assign the pull request to its author.
- Open the pull request as a draft.
