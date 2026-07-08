---
description: "Extract a custom controller action into a dedicated RESTful controller. Use this skill whenever a controller has a non-CRUD action (suspend, change_state, move_higher, send_job_offer…) that should become a new resource following this project's conventions. Generates the route, controller, view (if needed), and i18n keys, then updates all callers."
argument-hint: "[controller_file:line_or_action_name]"
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Edit", "Write"]
---

# Crudify — Extract a Custom Action into a CRUD Resource

Your goal is to extract a custom controller action and turn it into a new dedicated controller with a standard CRUD action. The original controller must only contain `index`, `show`, `new`, `create`, `edit`, `update`, `destroy` at the end.

**Target:** "$ARGUMENTS" (a file path, file:line, or action name — investigate from context if omitted)

---

## Step 1 — Read the source controller

Read the controller file and identify the custom action to extract:

- Its name (e.g., `suspend`, `change_state`, `move_higher`, `send_job_offer`)
- What HTTP verb it uses
- What model method it calls
- What it redirects to (or renders) after success
- Which `before_action` callbacks apply to it (and only to it)
- How authorization is handled (`load_and_authorize_resource`, `authorize! :action, @record`, `current_administrator.can?(...)`)
- Whether it renders a view or just redirects

---

## Step 2 — Determine the new resource

Map the custom action to a **noun** (the new resource) and a standard CRUD action:

| Custom action intent | CRUD action | Resource noun examples |
|---|---|---|
| Transition to a state (`suspend`, `archive`, `publish`) | `create` | `suspension`, `archive`, `publication` |
| Reverse a state transition (`unsuspend`, `unarchive`) | `destroy` | `suspension`, `archive` |
| Toggle (both directions in one action) | `update` | `archive`, `completion` |
| Display something (`board`, `stats`, `preview`) | `show` | `board`, `stat`, `preview` |
| Edit / reorder something (`move_higher`, `move_lower`, `rename`) | `update` | `position`, `rename` |

**Naming rules:**
- Use a singular noun (`resource :suspension`, not `resources :suspensions`) for state-per-parent transitions.
- Namespace the controller under the parent: `Admin::Users::SuspensionsController`, `Admin::JobApplications::StatesController`.
- Controller file goes in `app/controllers/<parent_namespace>/<resource>s_controller.rb`.

**Examples from this codebase (already crudified):**
- `suspend` / `unsuspend` on `Admin::UsersController` → `resource :suspension, only: %i[create destroy], module: :users` → `Admin::Users::SuspensionsController`
- `preselect_as_favorite` / `unpreselect_as_favorite` → `resource :favorite, only: %i[create destroy]` → `Admin::FavoritesController`
- bookmark a job offer → `resources :bookmarks, only: %i[create destroy]` → `BookmarksController`
- `validate` a job application file → `resource :validation, only: %i[create destroy], module: :job_application_files` → `Admin::JobApplicationFiles::ValidationsController`

---

## Step 3 — Find all callers

Search for every reference to the old route or action:

```bash
bin/rails routes | grep <action_name>   # get the old path helper name
```

Then grep for:
- The old path helper (e.g., `suspend_admin_user_path`)
- The old route path string
- Any `link_to`, `button_to`, `form_with`, `data-*`, `fetch(`, or Stimulus references in views/JS
- Usages in request specs (`spec/requests/...`)

---

## Step 4 — Generate the new files

### Route

In `config/routes.rb`, inside the parent resource block, replace the custom action with a nested `resource`:

```ruby
# Before
resources :users, path: "candidats" do
  member do
    post :suspend
    delete :unsuspend
  end
end

# After
resources :users, path: "candidats" do
  resource :suspension, only: %i[create destroy], module: :users
end
```

Use `resource` (singular) for one-per-parent state transitions.
Use `only:` to restrict to the actions actually needed, and `module:` to namespace the controller under the parent.

### Controller

Create `app/controllers/<parent_namespace>/<resource>s_controller.rb`. Admin controllers inherit from `Admin::BaseController`; front-office controllers inherit from `ApplicationController`.

```ruby
# frozen_string_literal: true

class Admin::Users::SuspensionsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :set_user
  before_action :authorize_suspension

  def create
    @user.suspend!
    redirect_back_or_to([:admin, @user], notice: t(".success"))
  end

  def destroy
    @user.unsuspend!
    redirect_back_or_to([:admin, @user], notice: t(".success"))
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def authorize_suspension
    authorize! :suspend, @user
  end
end
```

**Conventions:**
- Double quotes for all strings (rubocop / standard).
- One domain call per action, then `redirect_back_or_to([...], notice: t(".success"))`.
- Bang methods (`suspend!`) so failures raise.
- `before_action :set_<parent>` using a direct finder (`User.find(params[:user_id])`, `current_user.bookmarks.find_by!(...)`) — there is no org-scoped UUID finder in this project.
- Authorization uses **CanCanCan**: either `skip_load_and_authorize_resource` + `load_and_authorize_resource :parent`, or a manual `authorize! :action, @record` callback. Mirror the original action's authorization.
- Use `t(".success")` (dot-prefix relative key) for flash messages.
- `private` on its own line, blank line after it, methods indented two spaces.
- `# frozen_string_literal: true` magic comment is optional (the codebase is mixed) — match nearby files.

### View (only if the action renders a form or page)

For `create` / `destroy` that redirect, **no view is needed**.

If a view is needed (e.g., a confirmation form or a `show`/`board` page), create
`app/views/<parent_namespace>/<resource>s/<action>.html.erb` following the existing view conventions (DSFR components in the admin back-office).

### I18n

Add translation keys to both `config/locales/en.yml` and `config/locales/fr.yml`, under the controller's namespace (so that `t(".success")` resolves):

```yaml
# fr.yml
fr:
  admin:
    users:
      suspensions:
        create:
          success: "Utilisateur suspendu"
        destroy:
          success: "Utilisateur réactivé"
```

Mirror the exact same key path in `en.yml`. Keep locale files alphabetically ordered like their neighbours.

### Authorization (CanCanCan)

If the new action needs a permission, ensure the relevant ability is defined (e.g. in the `Ability` / administrator ability class) and `authorize!`d in the controller. Reuse the ability the original action relied on.

### Tests

Add **RSpec** request specs (this project uses RSpec, not Minitest), in
`spec/requests/<parent_namespace>/<resource>s_spec.rb`, following the project conventions in `CLAUDE.md`:

- A named `subject` per `describe`, triggered in a `before` block where the assertion is on `response`.
- One `expect` per example; prefer the one-liner / `is_expected` form when the assertion targets the subject.
- Hash shorthand (`job_offer:` rather than `job_offer: job_offer`).

```ruby
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Users::Suspensions" do
  let(:admin) { create(:administrator) }
  let(:user) { create(:confirmed_user) }

  before { sign_in admin }

  describe "POST /admin/candidats/:user_id/suspension" do
    subject(:create_request) { post admin_user_suspension_path(user) }

    it { expect { create_request }.to change { user.reload.suspended? }.to(true) }
  end
end
```

---

## Step 5 — Update existing code

1. **Remove the custom action** from the original controller (the action method itself).
2. **Remove the custom route** (the `post :suspend` / `member { ... }` line).
3. **Remove the `before_action` callback** if it was only used by the extracted action.
4. **Update all callers** found in step 3:
   - Views: replace old helpers with new ones (e.g., `suspend_admin_user_path(user)` → `admin_user_suspension_path(user)`), and adjust the HTTP verb on `button_to`/`link_to`.
   - Specs: update `post suspend_admin_user_path(...)` to `post admin_user_suspension_path(...)`.
   - JS/Stimulus: update any hardcoded path strings or data attributes.
5. **Update i18n keys** everywhere the old action's translation keys were used (views, controllers, mailers). Replace the old key path with the new controller namespace, and remove the old keys from the locale files.

---

## Step 6 — Verify

Run these checks and fix any issues:

```bash
bin/rails routes | grep <new_resource>            # confirm the route exists
bundle exec rubocop <new_controller_file>         # no lint errors
bundle exec rspec <new_spec> <modified_specs>     # specs green
```

---

## Output summary

When done, present:

```
## Crudification complete

### New files
- app/controllers/<parent_namespace>/<resource>s_controller.rb
- spec/requests/<parent_namespace>/<resource>s_spec.rb
- (app/views/... if a view was created)

### Updated files
- config/routes.rb — replaced `post :<action>` with `resource :<noun>`
- app/controllers/<original>_controller.rb — removed `<action>` action
- config/locales/en.yml — added <path>.success
- config/locales/fr.yml — added <path>.success
- <any views or specs updated>

### Route change
  Before: POST /parent/:id/<action>
  After:  POST /parent/:parent_id/<resource>
```
