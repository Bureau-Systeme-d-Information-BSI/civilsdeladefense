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
- In request and controller specs, trigger the subject in a `before` block and keep the `it` to a single line asserting on `response`, rather than calling the subject inside the `it`. For example, prefer:

  ```ruby
  describe "GET /admin/job_offers/:id/export" do
    subject(:export_request) { get export_admin_job_offer_path(job_offer) }

    before do
      create(:job_application, job_offer:)
      export_request
    end

    it { expect(response).to be_successful }
  end
  ```

  over:

  ```ruby
  it "returns a successful response" do
    export_request
    expect(response).to be_successful
  end
  ```
- When sibling `context` blocks under the same `describe` share an identical `before` that only triggers the subject, declare that `before` once at the `describe` level instead of repeating it in each `context` (each `context` keeps its own `subject`). For example, prefer:

  ```ruby
  describe "#resource_not_found" do
    before { perform }

    context "with xml format" do
      subject(:perform) { get :raise_not_found, format: :xml }

      it { expect(response).to have_http_status(:not_found) }
    end

    context "with json format" do
      subject(:perform) { get :raise_not_found, format: :json }

      it { expect(response).to have_http_status(:not_found) }
    end
  end
  ```

  over repeating `before { perform }` inside each `context`.
- Use Ruby's hash shorthand: write `key:` instead of `key: key` when the value is a variable or method of the same name. For example, prefer `create(:job_application, job_offer:)` over `create(:job_application, job_offer: job_offer)` (keep the explicit form when key and value differ, e.g. `organization: current_organization`).

## Pull requests

- Follow the project's pull request template (`.github/pull_request_template.md`): keep its sections (Description, Test plan, Review app, Links, Screenshots).
- Do not add a `Co-authored-by: Claude` trailer (or any Claude / Anthropic co-author) to commits or pull requests.
- Assign the pull request to its author.
- Open the pull request as a draft.
